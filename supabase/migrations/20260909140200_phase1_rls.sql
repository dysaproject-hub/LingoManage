-- Phase 1 Step 1: RLS for new tables + tighten existing policies

alter table public.organizations enable row level security;
alter table public.students enable row level security;
alter table public.invoices enable row level security;
alter table public.payments enable row level security;

create or replace function public.instructor_owns_course(p_course_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    public.is_platform_admin()
    or public.is_course_admin(p_course_id)
    or exists (
      select 1
      from public.courses c
      join public.organizations o on o.id = c.organization_id
      where c.id = p_course_id
        and o.owner_id = auth.uid()
    );
$$;

create or replace function public.instructor_owns_enrollment(p_enrollment_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.enrollments e
    where e.id = p_enrollment_id
      and public.instructor_owns_course(e.course_id)
  );
$$;

create or replace function public.instructor_owns_student(p_student_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.enrollments e
    where e.student_id = p_student_id
      and public.instructor_owns_course(e.course_id)
  );
$$;

-- ORGANIZATIONS
create policy "Owners manage own organization"
on public.organizations
for all
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

-- STUDENTS (no anon access; RPC uses SECURITY DEFINER)
create policy "Instructors read org students"
on public.students
for select
to authenticated
using (
  public.instructor_owns_student(id)
  or exists (
    select 1 from public.organizations o where o.owner_id = auth.uid()
  )
);

create policy "Instructors insert students"
on public.students
for insert
to authenticated
with check (
  exists (
    select 1 from public.organizations o where o.owner_id = auth.uid()
  )
);

create policy "Instructors update org students"
on public.students
for update
to authenticated
using (public.instructor_owns_student(id))
with check (public.instructor_owns_student(id));

-- INVOICES
create policy "Instructors manage org invoices"
on public.invoices
for all
to authenticated
using (public.instructor_owns_enrollment(enrollment_id))
with check (public.instructor_owns_enrollment(enrollment_id));

-- PAYMENTS
create policy "Instructors manage org payments"
on public.payments
for all
to authenticated
using (
  exists (
    select 1
    from public.invoices i
    where i.id = payments.invoice_id
      and public.instructor_owns_enrollment(i.enrollment_id)
  )
)
with check (
  exists (
    select 1
    from public.invoices i
    where i.id = payments.invoice_id
      and public.instructor_owns_enrollment(i.enrollment_id)
  )
);

-- COURSES: replace open marketplace policy
drop policy if exists "Authenticated users can view courses" on public.courses;

create policy "Instructors view own org courses"
on public.courses
for select
to authenticated
using (public.instructor_owns_course(id));

-- PROGRAMS: scope read to course admins / org owners
drop policy if exists "Authenticated users can view programs" on public.programs;

create policy "Instructors view org programs"
on public.programs
for select
to authenticated
using (public.instructor_owns_course(course_id));

-- ENROLLMENTS: remove student-auth policies (Phase 1: no student login flow)
drop policy if exists "Student can view own enrollments" on public.enrollments;
drop policy if exists "Students can create own enrollments" on public.enrollments;

create policy "Instructors insert org enrollments"
on public.enrollments
for insert
to authenticated
with check (public.instructor_owns_course(course_id));
