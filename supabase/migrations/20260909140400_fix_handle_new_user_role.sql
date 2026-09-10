-- Phase 1 Step 1: honor instructor role from signup metadata

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role text;
begin
  v_role := coalesce(new.raw_user_meta_data ->> 'role', 'student');

  if v_role not in ('student', 'instructor', 'platform_admin') then
    v_role := 'student';
  end if;

  insert into public.users (
    id,
    email,
    fullname,
    nickname,
    phone,
    role
  )
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data ->> 'fullname',
      new.raw_user_meta_data ->> 'full_name',
      ''
    ),
    new.raw_user_meta_data ->> 'nickname',
    new.raw_user_meta_data ->> 'phone',
    v_role
  );

  if v_role = 'instructor' then
    insert into public.organizations (name, owner_id)
    values (
      coalesce(
        nullif(trim(coalesce(
          new.raw_user_meta_data ->> 'fullname',
          new.raw_user_meta_data ->> 'full_name',
          ''
        )), ''),
        'Instruktur'
      ) || ' — Organisasi',
      new.id
    )
    on conflict (owner_id) do nothing;
  end if;

  return new;
end;
$$;
