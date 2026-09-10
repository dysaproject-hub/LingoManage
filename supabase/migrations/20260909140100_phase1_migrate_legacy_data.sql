-- Phase 1 Step 1: migrate legacy rows into organizations / students / invoices

-- One organization per course owner (instructor)
insert into public.organizations (name, owner_id)
select
  coalesce(nullif(trim(u.fullname), ''), 'Instruktur') || ' — Organisasi',
  c.owner_id
from public.courses c
join public.users u on u.id = c.owner_id
group by c.owner_id, u.fullname
on conflict (owner_id) do nothing;

-- Also create org for instructors without courses yet (registered but no course)
insert into public.organizations (name, owner_id)
select
  coalesce(nullif(trim(u.fullname), ''), 'Instruktur') || ' — Organisasi',
  u.id
from public.users u
where u.role = 'instructor'
on conflict (owner_id) do nothing;

update public.courses c
set
  organization_id = o.id,
  location = coalesce(nullif(trim(c.location), ''), nullif(trim(c.address), '')),
  registration_fee = coalesce((
    select coalesce(max(round(p.registration_fee)::integer), 0)
    from public.programs p
    where p.course_id = c.id
  ), 0),
  monthly_fee = coalesce((
    select coalesce(max(round(p.monthly_fee)::integer), 0)
    from public.programs p
    where p.course_id = c.id
  ), 0)
from public.organizations o
where o.owner_id = c.owner_id
  and c.organization_id is null;

-- Students from auth users referenced by enrollments
insert into public.students (full_name, phone, email, auth_user_id)
select
  coalesce(nullif(trim(u.fullname), ''), nullif(trim(e.fullname), ''), 'Siswa'),
  coalesce(
    nullif(public.normalize_phone(u.phone), ''),
    nullif(public.normalize_phone(e.fullname), ''),
    '0' || substr(replace(u.id::text, '-', ''), 1, 11)
  ),
  u.email,
  u.id
from (
  select distinct student_id
  from public.enrollments
) en
join public.users u on u.id = en.student_id
left join lateral (
  select e.fullname
  from public.enrollments e
  where e.student_id = u.id
  order by e.created_at desc
  limit 1
) e on true
on conflict (phone) do update
set
  auth_user_id = coalesce(public.students.auth_user_id, excluded.auth_user_id),
  full_name = case
    when public.students.full_name = 'Siswa' then excluded.full_name
    else public.students.full_name
  end,
  email = coalesce(public.students.email, excluded.email);

update public.enrollments
set
  source = coalesce(source, 'public_form'),
  approved_at = coalesce(approved_at, enrolled_at)
where source is null
   or (status = 'approved' and approved_at is null);

-- Remove duplicate (student user, course) pairs before strict unique index.
-- Keep the most relevant row: approved > pending > rejected > inactive.
with ranked as (
  select
    e.id,
    row_number() over (
      partition by e.student_id, e.course_id
      order by
        case e.status
          when 'approved' then 1
          when 'pending' then 2
          when 'rejected' then 3
          else 4
        end,
        e.created_at desc
    ) as rn
  from public.enrollments e
)
delete from public.enrollments e
using ranked r
where e.id = r.id
  and r.rn > 1;

-- Point enrollments.student_id to public.students (was auth.users)
alter table public.enrollments
  add column if not exists legacy_user_id uuid;

update public.enrollments
set legacy_user_id = student_id
where legacy_user_id is null;

alter table public.enrollments
  drop constraint if exists enrollments_student_id_fkey;

update public.enrollments e
set student_id = s.id
from public.students s
where s.auth_user_id = e.legacy_user_id;

-- Orphan enrollments without a mapped student row
insert into public.students (full_name, phone, notes)
select
  coalesce(nullif(trim(e.fullname), ''), 'Siswa'),
  '0' || substr(replace(e.id::text, '-', ''), 1, 11),
  'Migrated orphan enrollment'
from public.enrollments e
where not exists (
  select 1 from public.students s where s.id = e.student_id
)
on conflict (phone) do nothing;

update public.enrollments e
set student_id = s.id
from public.students s
where not exists (select 1 from public.students s2 where s2.id = e.student_id)
  and s.phone = '0' || substr(replace(e.id::text, '-', ''), 1, 11);

do $$
begin
  if exists (
    select 1
    from public.enrollments e
    left join public.students s on s.id = e.student_id
    where s.id is null
  ) then
    raise exception 'Phase 1 migration failed: enrollment without student mapping';
  end if;
end $$;

alter table public.enrollments
  alter column student_id set not null;

alter table public.enrollments
  add constraint enrollments_student_id_fkey
  foreign key (student_id) references public.students (id) on delete cascade;

alter table public.enrollments
  drop column if exists legacy_user_id;

alter table public.enrollments
  alter column source set not null;

drop index if exists public.unique_active_enrollment;

create unique index if not exists enrollments_student_course_unique
  on public.enrollments (student_id, course_id);

-- Backfill registration invoices for existing pending enrollments
insert into public.invoices (enrollment_id, type, amount, status)
select
  e.id,
  'registration',
  case
    when c.registration_fee <= 0 then 0
    else c.registration_fee
  end,
  case
    when c.registration_fee <= 0 then 'waived'
    else 'unpaid'
  end
from public.enrollments e
join public.courses c on c.id = e.course_id
where e.status = 'pending'
  and not exists (
    select 1
    from public.invoices i
    where i.enrollment_id = e.id
      and i.type = 'registration'
  );

-- Auto-approve zero-fee pending enrollments that were backfilled with waived invoice
update public.enrollments e
set
  status = 'approved',
  approved_at = coalesce(e.approved_at, now())
from public.courses c
where c.id = e.course_id
  and e.status = 'pending'
  and c.registration_fee <= 0;
