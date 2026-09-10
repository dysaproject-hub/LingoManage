# LingoManage Phase 1 — AI Build Spec

Use this document as the single source of truth.
Do not invent marketplace, student login, teacher payroll, or payment gateway features.
If a request conflicts with this spec, follow this spec.

## 1. Product

LingoManage Phase 1 is a multi-tenant course management SaaS for small course providers in Indonesia (English courses, tutoring centers, music schools, etc.).

Primary user: instructor / course admin.
Secondary actor: prospective student filling a public web form (NO student account).

Promise:
Admin can record enrollments, registration fees, and monthly invoices without spreadsheets.

Not in Phase 1:
- student mobile app login
- public course marketplace / search
- teacher salary / payout
- Midtrans / Xendit / any payment gateway
- chat
- attendance hardware
- subscriptions billed by the platform

## 2. Stack

- Flutter app for instructors (Android first; iOS later if asked)
- Public student registration as a lightweight web page
  Preferred: Flutter Web route(s) in the same repo OR a simple separate web page hitting the same Supabase project
- Supabase: Auth, Postgres, Storage, Row Level Security
- Language: Dart for Flutter, SQL for migrations
- State: keep it simple (Riverpod or Provider). Do not add extra architecture layers unless needed.

## 3. Roles

- `instructor`: authenticated Supabase user who owns or belongs to one organization
- `student_record`: database person only. No auth user in Phase 1
- Platform super-admin is OUT OF SCOPE

One instructor creates one organization during onboarding.
Phase 1: one owner per organization. No staff invites yet unless explicitly requested.

## 4. Domain model

organization
  has many courses
  has payment account fields

course
  belongs to organization
  has many enrollments

student
  has many enrollments
  no auth required

enrollment
  belongs to student + course
  has many invoices

invoice
  belongs to enrollment
  has many payments (usually 0 or 1 in Phase 1)

## 5. Status enums

enrollment.status:
- pending
- approved
- rejected
- inactive

enrollment.source:
- public_form
- manual_add

invoice.type:
- registration
- monthly

invoice.status:
- unpaid
- paid
- waived
- overdue

## 6. Business rules (must implement)

1. Public form submit NEVER auto-approves.
2. New student via public form:
   - create/reuse student by phone
   - create enrollment status=pending, source=public_form
   - create invoice type=registration, status=unpaid, amount=course.registration_fee
   - if registration_fee is 0, invoice may be waived and enrollment may be approved automatically
3. Enrollment becomes approved only if registration invoice is paid OR waived.
4. Manual add of existing student:
   - enrollment status=approved, source=manual_add
   - registration invoice waived
   - monthly invoice for current period is optional via checkbox
5. Unique enrollment per (student_id, course_id).
   If pair exists, do not duplicate. Show current status.
6. Phone number is the student unique key inside the system (normalize to digits, Indonesian 08 / 62 accepted, store consistent format).
7. Monthly invoices only for approved enrollments.
8. Do not create two monthly invoices for the same enrollment + same period (YYYY-MM).
9. Payment destination is organization bank/QRIS fields, NOT per-course account numbers.
10. Course stores prices only: registration_fee, monthly_fee.
11. Instructor can mark invoice paid manually. Proof upload is optional.
12. Rejected enrollment does not get approved until admin changes status; unpaid registration stays unpaid.

## 7. Database schema

Use Supabase SQL migration. Enable RLS on all tables.

```sql
create extension if not exists "pgcrypto";

create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_id uuid not null references auth.users(id),
  bank_name text,
  account_number text,
  account_name text,
  qris_url text,
  payment_notes text,
  created_at timestamptz not null default now()
);

create table courses (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  name text not null,
  category text,
  description text,
  location text,
  is_online boolean not null default false,
  registration_fee integer not null default 0,
  monthly_fee integer not null default 0,
  quota integer,
  is_published boolean not null default true,
  created_at timestamptz not null default now()
);

create table students (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text not null,
  email text,
  notes text,
  auth_user_id uuid null,
  created_at timestamptz not null default now()
);

create unique index students_phone_unique on students (phone);

create table enrollments (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references students(id) on delete cascade,
  course_id uuid not null references courses(id) on delete cascade,
  status text not null check (status in ('pending','approved','rejected','inactive')),
  source text not null check (source in ('public_form','manual_add')),
  created_at timestamptz not null default now(),
  approved_at timestamptz,
  unique (student_id, course_id)
);

create table invoices (
  id uuid primary key default gen_random_uuid(),
  enrollment_id uuid not null references enrollments(id) on delete cascade,
  type text not null check (type in ('registration','monthly')),
  period text,
  amount integer not null default 0,
  due_date date,
  status text not null check (status in ('unpaid','paid','waived','overdue')),
  paid_at timestamptz,
  created_at timestamptz not null default now()
);

create unique index invoices_monthly_unique
  on invoices (enrollment_id, type, period)
  where type = 'monthly';

create table payments (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references invoices(id) on delete cascade,
  amount integer not null,
  proof_url text,
  note text,
  recorded_by uuid references auth.users(id),
  recorded_at timestamptz not null default now()
);
```

Add helper: organization membership via owner_id for Phase 1.
Later a membership table can replace this. Do not overbuild now.

### RLS intent

- Instructor authenticated.
- Can CRUD organizations where owner_id = auth.uid().
- Can CRUD courses / enrollments / invoices / payments only through their organization.
- Students table: instructor can read/write students who have enrollments in their courses. For public form inserts, use a Supabase RPC or restricted insert policy.
- Public form must NOT allow reading other students.
- Implement public registration via `submit_registration` SECURITY DEFINER RPC:
  inputs: course_id, full_name, phone, email, notes
  server checks course.is_published
  upsert student by phone
  insert enrollment if missing
  insert registration invoice if new pending enrollment
  return enrollment_id + payment instructions from organization
- Anonymous users can execute only that RPC, nothing else.

## 8. Public registration RPC contract

Function: `submit_registration`

Input:
- course_id uuid
- full_name text
- phone text
- email text null
- notes text null

Output JSON:
- ok boolean
- message text
- enrollment_id uuid
- enrollment_status text
- already_exists boolean
- payment: { bank_name, account_number, account_name, qris_url, payment_notes, amount, invoice_id, invoice_status }

Behavior:
- If enrollment already pending: return already_exists=true and same payment info
- If enrollment already approved: return already_exists=true, amount 0, message that student is already active
- Never leak other students’ data

## 9. Instructor app screens

Build only these screens.

1. Splash / session check
2. Login + Register instructor
3. Onboarding: organization name + bank account fields
4. Home dashboard
   - count pending enrollments
   - count unpaid invoices
   - shortcut to courses
5. Course list
6. Course create/edit
7. Course detail
   - copy public form link
   - pending enrollments list
   - active students list
   - add existing student button
8. Add student form (manual)
9. Enrollment detail
   - student info
   - invoices
   - actions: mark paid, approve, reject, set inactive
10. Invoices list with filters: unpaid / paid / overdue
11. Settings: organization + payment account

Public web:
12. `/daftar/:courseId` form
13. `/daftar/:courseId/sukses` payment instructions

## 10. Form fields

### Course
- name (required)
- category
- description
- location
- is_online
- registration_fee (IDR integer)
- monthly_fee (IDR integer)
- quota (optional)
- is_published

### Public student form
- full_name (required)
- phone (required)
- email optional
- notes optional
No password. No file upload required in Phase 1.

### Manual add student
- full_name
- phone
- email optional
- notes optional
- course (preselected)
- create_current_month_invoice boolean default false

### Mark paid
- optional note
- optional proof image to Storage bucket `payment-proofs`

## 11. Copy / UX language

UI language: Bahasa Indonesia.
Money: Rupiah, format `Rp 150.000`.
Phone helper text: `08xxxxxxxxxx`.
Success form copy must show organization payment destination and registration amount.
Pending list must make it obvious: belum boleh masuk kelas sebelum lunas / di-approve.

## 12. Build order for the AI

Complete in this exact order. Do not skip ahead.

Step 1: Supabase migration + enums + RLS + RPC submit_registration
Step 2: Flutter auth (email/password is fine) + organization onboarding
Step 3: Course CRUD
Step 4: Public registration web form + success page
Step 5: Pending queue + enrollment detail + approve/reject
Step 6: Mark invoice paid + payment proof optional
Step 7: Manual add student
Step 8: Monthly invoice create action (manual button “Buat tagihan bulan ini” on course or invoice page)
Step 9: Dashboard counts + copy form link
Step 10: Polish empty states and error messages

## 13. Acceptance tests

Must pass before adding any Phase 2 feature:

1. Instructor can sign up, create organization, add bank account, create a course.
2. Opening public form for that course allows submit without login.
3. Submit creates student + pending enrollment + unpaid registration invoice.
4. Submitting again with same phone + course does not create a second enrollment.
5. Instructor sees the pending enrollment.
6. Instructor cannot approve until registration invoice is paid or fee is 0.
7. Marking invoice paid allows approve; student appears in active list.
8. Manual add puts student in active list without registration fee.
9. Instructor A cannot see instructor B courses or students.
10. Public anonymous user cannot select * from students.

## 14. Folder conventions (Flutter)

```
lib/
  main.dart
  app.dart
  core/           theme, formatters, supabase client
  features/
    auth/
    organization/
    courses/
    enrollments/
    invoices/
    public_register/
  widgets/
```

Keep features thin. No Clean Architecture ceremony. No unnecessary entities/repositories if a simple service class is enough.

## 15. Explicit non-goals

Do not build:
- student authentication
- invite links with passwords
- course discovery homepage
- ratings/reviews
- teacher accounts separate from organization owner
- payroll
- WhatsApp API integration (only “copy text/link”)
- subscription billing for the SaaS itself
- notifications beyond in-app lists
- Excel import
- multi-branch complexity

## 16. When the human asks for extra features

If they ask for marketplace, student app, or payment gateway:
- say it is Phase 2+
- finish any incomplete Phase 1 acceptance test first
- do not mix the extra feature into Phase 1 tables in a breaking way
- student login later uses students.auth_user_id nullable column already reserved
