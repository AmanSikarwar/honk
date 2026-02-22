-- Add full_name and profile_url columns to profiles
alter table public.profiles
  add column if not exists full_name text,
  add column if not exists profile_url text;

-- Re-create handle_new_auth_user to also populate full_name and profile_url
-- from auth user metadata (works for Google OAuth and other providers).
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  generated_username text;
  v_full_name        text;
  v_profile_url      text;
begin
  generated_username := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'username'), ''),
    'user_' || left(new.id::text, 8)
  );

  v_full_name := nullif(
    trim(coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name',
      ''
    )),
    ''
  );

  v_profile_url := nullif(
    trim(coalesce(
      new.raw_user_meta_data ->> 'avatar_url',
      new.raw_user_meta_data ->> 'picture',
      ''
    )),
    ''
  );

  insert into public.profiles (id, username, full_name, profile_url)
  values (new.id, generated_username, v_full_name, v_profile_url)
  on conflict (id) do update
  set
    username    = excluded.username,
    full_name   = coalesce(excluded.full_name,  public.profiles.full_name),
    profile_url = coalesce(excluded.profile_url, public.profiles.profile_url);

  return new;
end;
$$;

-- Update get_honk_activity_effective_statuses to expose full_name and profile_url
create or replace function public.get_honk_activity_effective_statuses(
  p_activity_id    uuid,
  p_occurrence_start timestamptz
)
returns table (
  user_id            uuid,
  username           text,
  full_name          text,
  profile_url        text,
  role               text,
  effective_status_key text,
  status_updated_at  timestamptz,
  status_expires_at  timestamptz
)
language sql
security definer
set search_path = public
as $$
  with default_status as (
    select o.status_key
    from public.honk_activity_status_options o
    where o.activity_id = p_activity_id
      and o.is_active = true
      and o.is_default = true
    limit 1
  )
  select
    p.user_id,
    pr.username,
    pr.full_name,
    pr.profile_url,
    p.role,
    case
      when s.expires_at is not null and s.expires_at > timezone('utc'::text, now()) then s.status_key
      else (select d.status_key from default_status d)
    end as effective_status_key,
    s.updated_at as status_updated_at,
    s.expires_at  as status_expires_at
  from public.honk_activity_participants p
  join public.profiles pr on pr.id = p.user_id
  left join public.honk_participant_statuses s
    on s.activity_id = p.activity_id
   and s.user_id     = p.user_id
   and s.occurrence_start = p_occurrence_start
  where p.activity_id = p_activity_id
    and p.left_at is null;
$$;

-- Rebuild get_honk_activity_details so participants include full_name and profile_url
create or replace function public.get_honk_activity_details(
  p_activity_id      uuid,
  p_occurrence_start timestamptz default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id          uuid := (select auth.uid());
  v_activity         record;
  v_occurrence_start timestamptz;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if not public.can_access_honk_activity(p_activity_id, v_user_id) then
    raise exception 'Not authorized to access this activity.';
  end if;

  select *
  into v_activity
  from public.honk_activities a
  where a.id = p_activity_id;

  if v_activity.id is null then
    return null;
  end if;

  v_occurrence_start := coalesce(p_occurrence_start, v_activity.starts_at);

  return jsonb_build_object(
    'activity',          to_jsonb(v_activity),
    'occurrence_start',  v_occurrence_start,
    'status_options', (
      select coalesce(
        jsonb_agg(to_jsonb(o) order by o.sort_order asc, o.status_key asc),
        '[]'::jsonb
      )
      from public.honk_activity_status_options o
      where o.activity_id = p_activity_id
        and o.is_active = true
    ),
    'participants', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'user_id',             s.user_id,
            'username',            s.username,
            'full_name',           s.full_name,
            'profile_url',         s.profile_url,
            'role',                s.role,
            'effective_status_key', s.effective_status_key,
            'status_updated_at',   s.status_updated_at,
            'status_expires_at',   s.status_expires_at
          )
          order by s.username asc
        ),
        '[]'::jsonb
      )
      from public.get_honk_activity_effective_statuses(p_activity_id, v_occurrence_start) s
    )
  );
end;
$$;
