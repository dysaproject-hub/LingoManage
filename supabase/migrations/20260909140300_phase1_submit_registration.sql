-- Phase 1 Step 1: public registration RPC (anonymous only)

create or replace function public.submit_registration(
  p_course_id uuid,
  p_full_name text,
  p_phone text,
  p_email text default null,
  p_notes text default null
)
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  v_phone text;
  v_course public.courses%rowtype;
  v_org public.organizations%rowtype;
  v_student_id uuid;
  v_enrollment_id uuid;
  v_enrollment_status text;
  v_invoice_id uuid;
  v_invoice_status text;
  v_amount integer;
  v_already_exists boolean := false;
  v_message text;
begin
  v_phone := public.normalize_phone(p_phone);

  if v_phone = '' or length(v_phone) < 10 then
    return json_build_object(
      'ok', false,
      'message', 'Nomor telepon tidak valid'
    );
  end if;

  if coalesce(trim(p_full_name), '') = '' then
    return json_build_object(
      'ok', false,
      'message', 'Nama lengkap wajib diisi'
    );
  end if;

  select * into v_course
  from public.courses
  where id = p_course_id;

  if not found or not coalesce(v_course.is_published, false) then
    return json_build_object(
      'ok', false,
      'message', 'Kursus tidak ditemukan atau tidak tersedia'
    );
  end if;

  select * into v_org
  from public.organizations
  where id = v_course.organization_id;

  if not found then
    return json_build_object(
      'ok', false,
      'message', 'Organisasi kursus belum dikonfigurasi'
    );
  end if;

  insert into public.students (full_name, phone, email, notes)
  values (trim(p_full_name), v_phone, p_email, p_notes)
  on conflict (phone) do update
    set
      full_name = excluded.full_name,
      email = coalesce(excluded.email, public.students.email),
      notes = coalesce(excluded.notes, public.students.notes)
  returning id into v_student_id;

  select id, status
  into v_enrollment_id, v_enrollment_status
  from public.enrollments
  where student_id = v_student_id
    and course_id = p_course_id;

  if found then
    v_already_exists := true;

    select i.id, i.status, i.amount
    into v_invoice_id, v_invoice_status, v_amount
    from public.invoices i
    where i.enrollment_id = v_enrollment_id
      and i.type = 'registration'
    order by i.created_at desc
    limit 1;

    if v_enrollment_status = 'approved' then
      return json_build_object(
        'ok', true,
        'message', 'Siswa sudah aktif di kursus ini',
        'enrollment_id', v_enrollment_id,
        'enrollment_status', v_enrollment_status,
        'already_exists', true,
        'payment', json_build_object(
          'bank_name', v_org.bank_name,
          'account_number', v_org.account_number,
          'account_name', v_org.account_name,
          'qris_url', v_org.qris_url,
          'payment_notes', v_org.payment_notes,
          'amount', 0,
          'invoice_id', v_invoice_id,
          'invoice_status', v_invoice_status
        )
      );
    end if;

    v_message := case v_enrollment_status
      when 'pending' then 'Pendaftaran masih menunggu persetujuan'
      when 'rejected' then 'Pendaftaran sebelumnya ditolak'
      else 'Pendaftaran sudah ada'
    end;

    return json_build_object(
      'ok', true,
      'message', v_message,
      'enrollment_id', v_enrollment_id,
      'enrollment_status', v_enrollment_status,
      'already_exists', true,
      'payment', json_build_object(
        'bank_name', v_org.bank_name,
        'account_number', v_org.account_number,
        'account_name', v_org.account_name,
        'qris_url', v_org.qris_url,
        'payment_notes', v_org.payment_notes,
        'amount', coalesce(v_amount, v_course.registration_fee),
        'invoice_id', v_invoice_id,
        'invoice_status', v_invoice_status
      )
    );
  end if;

  if v_course.registration_fee <= 0 then
    insert into public.enrollments (student_id, course_id, status, source, approved_at)
    values (v_student_id, p_course_id, 'approved', 'public_form', now())
    returning id, status into v_enrollment_id, v_enrollment_status;

    insert into public.invoices (enrollment_id, type, amount, status, paid_at)
    values (v_enrollment_id, 'registration', 0, 'waived', now())
    returning id, status, amount
    into v_invoice_id, v_invoice_status, v_amount;

    v_message := 'Pendaftaran berhasil. Biaya pendaftaran gratis.';
  else
    insert into public.enrollments (student_id, course_id, status, source)
    values (v_student_id, p_course_id, 'pending', 'public_form')
    returning id, status into v_enrollment_id, v_enrollment_status;

    insert into public.invoices (enrollment_id, type, amount, status)
    values (v_enrollment_id, 'registration', v_course.registration_fee, 'unpaid')
    returning id, status, amount
    into v_invoice_id, v_invoice_status, v_amount;

    v_message := 'Pendaftaran berhasil. Silakan bayar biaya pendaftaran.';
  end if;

  return json_build_object(
    'ok', true,
    'message', v_message,
    'enrollment_id', v_enrollment_id,
    'enrollment_status', v_enrollment_status,
    'already_exists', false,
    'payment', json_build_object(
      'bank_name', v_org.bank_name,
      'account_number', v_org.account_number,
      'account_name', v_org.account_name,
      'qris_url', v_org.qris_url,
      'payment_notes', v_org.payment_notes,
      'amount', coalesce(v_amount, v_course.registration_fee),
      'invoice_id', v_invoice_id,
      'invoice_status', v_invoice_status
    )
  );
end;
$$;

revoke all on function public.submit_registration(uuid, text, text, text, text)
from public;

grant execute on function public.submit_registration(uuid, text, text, text, text)
to anon;
