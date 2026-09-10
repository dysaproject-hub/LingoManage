-- Phase 1 Step 1: core tables + helpers (no data migration yet)
create extension if not exists "pgcrypto";

-- Normalize Indonesian phone numbers to 0xxxxxxxxxx
create or replace function public.normalize_phone(raw text)
returns text
language plpgsql
immutable
as $$
declare
  digits text;
begin
  digits := regexp_replace(coalesce(raw, ''), '[^0-9]', '', 'g');

  if digits = '' then
    return '';
  end if;

  if digits like '62%' and length(digits) > 2 then
    return '0' || substring(digits from 3);
  end if;

  if digits like '8%' then
    return '0' || digits;
  end if;

  return digits;
end;
$$;

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_id uuid not null references auth.users (id) on delete restrict,
  bank_name text,
  account_number text,
  account_name text,
  qris_url text,
  payment_notes text,
  created_at timestamptz not null default now()
);

create unique index organizations_owner_id_unique
  on public.organizations (owner_id);

create table public.students (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text not null,
  email text,
  notes text,
  auth_user_id uuid null references auth.users (id) on delete set null,
  created_at timestamptz not null default now()
);

create unique index students_phone_unique on public.students (phone);

create table public.invoices (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null references public.enrollments (id) on delete cascade,
  type text not null check (type in ('registration', 'monthly')),
  period text,
  amount integer not null default 0,
  due_date date,
  status text not null check (status in ('unpaid', 'paid', 'waived', 'overdue')),
  paid_at timestamptz,
  created_at timestamptz not null default now()
);

create unique index invoices_monthly_unique
  on public.invoices (enrollment_id, type, period)
  where type = 'monthly';

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references public.invoices (id) on delete cascade,
  amount integer not null,
  proof_url text,
  note text,
  recorded_by uuid references auth.users (id),
  recorded_at timestamptz not null default now()
);

-- Extend courses toward Phase 1 spec (keep owner_id for legacy Flutter)
alter table public.courses
  add column if not exists organization_id uuid references public.organizations (id) on delete cascade,
  add column if not exists category text,
  add column if not exists location text,
  add column if not exists is_online boolean not null default false,
  add column if not exists registration_fee integer not null default 0,
  add column if not exists monthly_fee integer not null default 0,
  add column if not exists quota integer,
  add column if not exists is_published boolean not null default true;

create index if not exists idx_courses_organization_id
  on public.courses (organization_id);

-- Extend enrollments toward Phase 1 spec
alter table public.enrollments
  add column if not exists source text,
  add column if not exists approved_at timestamptz;

alter table public.enrollments
  alter column program_id drop not null;

alter table public.enrollments
  drop constraint if exists enrollments_status_check;

update public.enrollments
set status = 'inactive'
where status = 'cancelled';

alter table public.enrollments
  add constraint enrollments_status_check
  check (status in ('pending', 'approved', 'rejected', 'inactive'));

alter table public.enrollments
  drop constraint if exists enrollments_source_check;

alter table public.enrollments
  add constraint enrollments_source_check
  check (source is null or source in ('public_form', 'manual_add'));

-- Auto-link new courses to the instructor organization (legacy insert path)
create or replace function public.ensure_course_organization()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  org_id uuid;
begin
  if new.organization_id is not null then
    return new;
  end if;

  if new.owner_id is null then
    raise exception 'Course requires owner_id or organization_id';
  end if;

  select id into org_id
  from public.organizations
  where owner_id = new.owner_id;

  if org_id is null then
    insert into public.organizations (name, owner_id)
    values ('Organisasi Saya', new.owner_id)
    returning id into org_id;
  end if;

  new.organization_id := org_id;
  return new;
end;
$$;

drop trigger if exists trg_ensure_course_organization on public.courses;

create trigger trg_ensure_course_organization
before insert or update of owner_id, organization_id
on public.courses
for each row
execute function public.ensure_course_organization();
