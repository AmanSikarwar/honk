-- ============================================================
-- Migration: Remove start-time, recurrence, and occurrence_start
-- ============================================================
-- Drop starts_at, recurrence_rrule, recurrence_timezone from honk_activities.
-- Simplify honk_participant_statuses PK: drop occurrence_start, new PK is (activity_id, user_id).
-- Update all affected RPCs to their post-change signatures.
-- ============================================================

-- ── 1. Drop columns from honk_activities ─────────────────────────────────────

alter table public.honk_activities
  drop column if exists starts_at,
  drop column if exists recurrence_rrule,
  drop column if exists recurrence_timezone;

-- ── 2. Simplify honk_participant_statuses ─────────────────────────────────────

-- Drop all constraints that reference occurrence_start or the old PK.
alter table public.honk_participant_statuses
  drop constraint if exists honk_participant_statuses_pkey,
  drop constraint if exists honk_participant_statuses_expiry_after_update,
  drop constraint if exists honk_participant_statuses_status_fk;

drop index if exists idx_honk_participant_statuses_activity_occurrence;

-- Deduplicate: keep only the most-recently-updated row per (activity_id, user_id).
delete from public.honk_participant_statuses a
using public.honk_participant_statuses b
where a.activity_id = b.activity_id
  and a.user_id = b.user_id
  and a.updated_at < b.updated_at;

-- Drop occurrence_start column.
alter table public.honk_participant_statuses
  drop column if exists occurrence_start;

-- Re-add PK, check constraint, and FK.
alter table public.honk_participant_statuses
  add primary key (activity_id, user_id);

alter table public.honk_participant_statuses
  add constraint honk_participant_statuses_expiry_after_update
    check (expires_at > updated_at);

alter table public.honk_participant_statuses
  add constraint honk_participant_statuses_status_fk
    foreign key (activity_id, status_key)
    references public.honk_activity_status_options (activity_id, status_key)
    on delete restrict;

-- ── 3. Update set_honk_status (drop p_occurrence_start) ───────────────────────

create or replace function public.set_honk_status(
  p_activity_id uuid,
  p_status_key  text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id              uuid := (select auth.uid());
  v_status_reset_seconds integer;
  v_expires_at           timestamptz;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if p_status_key is null or trim(p_status_key) = '' then
    raise exception 'status_key is required.';
  end if;

  if not exists (
    select 1
    from public.honk_activity_participants p
    where p.activity_id = p_activity_id
      and p.user_id     = v_user_id
      and p.left_at is null
  ) then
    raise exception 'Only active participants can set status.';
  end if;

  if not exists (
    select 1
    from public.honk_activity_status_options o
    where o.activity_id = p_activity_id
      and o.status_key  = trim(p_status_key)
      and o.is_active   = true
  ) then
    raise exception 'Invalid status key for this activity.';
  end if;

  select a.status_reset_seconds
  into   v_status_reset_seconds
  from   public.honk_activities a
  where  a.id = p_activity_id;

  v_expires_at := timezone('utc'::text, now())
                + make_interval(secs => v_status_reset_seconds);

  insert into public.honk_participant_statuses (
    activity_id, user_id, status_key, updated_at, expires_at
  )
  values (
    p_activity_id, v_user_id, trim(p_status_key),
    timezone('utc'::text, now()), v_expires_at
  )
  on conflict (activity_id, user_id) do update
    set status_key = excluded.status_key,
        updated_at = excluded.updated_at,
        expires_at = excluded.expires_at;

  return jsonb_build_object(
    'activity_id', p_activity_id,
    'user_id',     v_user_id,
    'status_key',  trim(p_status_key),
    'expires_at',  v_expires_at
  );
end;
$$;

-- ── 4. Update get_honk_activity_effective_statuses (drop p_occurrence_start) ──

create or replace function public.get_honk_activity_effective_statuses(
  p_activity_id uuid
)
returns table (
  user_id              uuid,
  username             text,
  full_name            text,
  profile_url          text,
  role                 text,
  effective_status_key text,
  status_updated_at    timestamptz,
  status_expires_at    timestamptz
)
language sql
security definer
set search_path = public
as $$
  with default_status as (
    select o.status_key
    from   public.honk_activity_status_options o
    where  o.activity_id = p_activity_id
      and  o.is_active   = true
      and  o.is_default  = true
    limit 1
  )
  select
    p.user_id,
    pr.username,
    pr.full_name,
    pr.profile_url,
    p.role,
    case
      when s.expires_at is not null
       and s.expires_at > timezone('utc'::text, now())
        then s.status_key
      else (select d.status_key from default_status d)
    end as effective_status_key,
    s.updated_at as status_updated_at,
    s.expires_at as status_expires_at
  from       public.honk_activity_participants p
  join       public.profiles                   pr on pr.id = p.user_id
  left join  public.honk_participant_statuses  s
               on  s.activity_id = p.activity_id
               and s.user_id     = p.user_id
  where p.activity_id = p_activity_id
    and p.left_at is null;
$$;

-- ── 5. Update get_honk_activity_details (drop occurrence_start logic) ─────────

create or replace function public.get_honk_activity_details(
  p_activity_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_activity record;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if not public.can_access_honk_activity(p_activity_id, v_user_id) then
    raise exception 'Not authorized to access this activity.';
  end if;

  select *
  into   v_activity
  from   public.honk_activities a
  where  a.id = p_activity_id;

  if v_activity.id is null then
    return null;
  end if;

  return jsonb_build_object(
    'status_options', (
      select coalesce(
        jsonb_agg(to_jsonb(o) order by o.sort_order asc, o.status_key asc),
        '[]'::jsonb
      )
      from public.honk_activity_status_options o
      where o.activity_id = p_activity_id
        and o.is_active   = true
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
      from public.get_honk_activity_effective_statuses(p_activity_id) s
    )
  );
end;
$$;

-- ── 6. Update create_honk_activity (drop time/recurrence params) ──────────────

create or replace function public.create_honk_activity(
  p_activity             text,
  p_location             text,
  p_details              text,
  p_status_reset_seconds integer,
  p_status_options       jsonb,
  p_participant_ids      uuid[] default '{}'::uuid[]
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id       uuid := (select auth.uid());
  v_activity_id   uuid;
  v_invite_code   text;
  v_option_count  integer := 0;
  v_default_count integer := 0;
  v_option        jsonb;
  v_status_key    text;
  v_label         text;
  v_sort_order    integer;
  v_is_default    boolean;
  v_participant_id uuid;
  v_attempt       integer := 0;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if p_activity is null or char_length(trim(p_activity)) = 0 then
    raise exception 'Activity is required.';
  end if;

  if p_location is null or char_length(trim(p_location)) = 0 then
    raise exception 'Location is required.';
  end if;

  if p_status_reset_seconds is null or p_status_reset_seconds <= 0 then
    raise exception 'status_reset_seconds must be > 0.';
  end if;

  if p_status_options is null or jsonb_typeof(p_status_options) <> 'array' then
    raise exception 'status_options must be a JSON array.';
  end if;

  for v_option in select value from jsonb_array_elements(p_status_options) loop
    v_option_count := v_option_count + 1;
    v_status_key   := trim(coalesce(v_option ->> 'status_key', ''));
    v_label        := trim(coalesce(v_option ->> 'label',      ''));
    v_is_default   := coalesce((v_option ->> 'is_default')::boolean, false);

    if v_status_key = '' or v_status_key !~ '^[a-z0-9_]+$' then
      raise exception 'Invalid status_key in status_options.';
    end if;
    if v_label = '' then
      raise exception 'status option label cannot be empty.';
    end if;
    if v_is_default then
      v_default_count := v_default_count + 1;
    end if;
  end loop;

  if v_option_count < 2 or v_option_count > 8 then
    raise exception 'status_options must contain between 2 and 8 items.';
  end if;
  if v_default_count <> 1 then
    raise exception 'Exactly one default status option is required.';
  end if;

  while v_activity_id is null loop
    v_attempt := v_attempt + 1;
    if v_attempt > 10 then
      raise exception 'Unable to generate unique invite code.';
    end if;
    begin
      v_invite_code := public.generate_honk_invite_code();
      insert into public.honk_activities (
        creator_id, activity, location, details,
        status_reset_seconds, invite_code
      )
      values (
        v_user_id,
        trim(p_activity),
        trim(p_location),
        nullif(trim(coalesce(p_details, '')), ''),
        p_status_reset_seconds,
        v_invite_code
      )
      returning id into v_activity_id;
    exception
      when unique_violation then v_activity_id := null;
    end;
  end loop;

  for v_option in select value from jsonb_array_elements(p_status_options) loop
    v_status_key := trim(v_option ->> 'status_key');
    v_label      := trim(v_option ->> 'label');
    v_sort_order := coalesce((v_option ->> 'sort_order')::integer, 0);
    v_is_default := coalesce((v_option ->> 'is_default')::boolean, false);

    insert into public.honk_activity_status_options (
      activity_id, status_key, label, sort_order, is_default, is_active
    )
    values (v_activity_id, v_status_key, v_label, v_sort_order, v_is_default, true);
  end loop;

  insert into public.honk_activity_participants (activity_id, user_id, role)
  values (v_activity_id, v_user_id, 'creator')
  on conflict (activity_id, user_id) do update
    set role = excluded.role,
        joined_at = timezone('utc'::text, now()),
        left_at = null;

  -- Pre-invite accepted friends (friendship check still in place until next migration).
  foreach v_participant_id in array p_participant_ids loop
    if v_participant_id = v_user_id then continue; end if;

    if not public.are_users_accepted_friends(v_user_id, v_participant_id) then
      raise exception 'Participant % is not an accepted friend.', v_participant_id;
    end if;

    insert into public.honk_activity_participants (activity_id, user_id, role)
    values (v_activity_id, v_participant_id, 'participant')
    on conflict (activity_id, user_id) do update
      set role = excluded.role,
          joined_at = timezone('utc'::text, now()),
          left_at = null;
  end loop;

  return jsonb_build_object(
    'activity_id', v_activity_id,
    'invite_code', v_invite_code
  );
end;
$$;

-- ── 7. Update update_honk_activity (drop time/recurrence params) ──────────────

create or replace function public.update_honk_activity(
  p_activity_id          uuid,
  p_activity             text,
  p_location             text,
  p_details              text,
  p_status_reset_seconds integer,
  p_status_options       jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id       uuid := (select auth.uid());
  v_option        jsonb;
  v_option_count  integer := 0;
  v_default_count integer := 0;
  v_status_key    text;
  v_label         text;
  v_sort_order    integer;
  v_is_default    boolean;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if not exists (
    select 1 from public.honk_activities a
    where a.id = p_activity_id and a.creator_id = v_user_id
  ) then
    raise exception 'Only creator can update this activity.';
  end if;

  if p_activity is null or char_length(trim(p_activity)) = 0 then
    raise exception 'Activity is required.';
  end if;

  if p_location is null or char_length(trim(p_location)) = 0 then
    raise exception 'Location is required.';
  end if;

  if p_status_reset_seconds is null or p_status_reset_seconds <= 0 then
    raise exception 'status_reset_seconds must be > 0.';
  end if;

  if p_status_options is null or jsonb_typeof(p_status_options) <> 'array' then
    raise exception 'status_options must be a JSON array.';
  end if;

  for v_option in select value from jsonb_array_elements(p_status_options) loop
    v_option_count := v_option_count + 1;
    v_status_key   := trim(coalesce(v_option ->> 'status_key', ''));
    v_label        := trim(coalesce(v_option ->> 'label',      ''));
    v_is_default   := coalesce((v_option ->> 'is_default')::boolean, false);

    if v_status_key = '' or v_status_key !~ '^[a-z0-9_]+$' then
      raise exception 'Invalid status_key in status_options.';
    end if;
    if v_label = '' then
      raise exception 'status option label cannot be empty.';
    end if;
    if v_is_default then
      v_default_count := v_default_count + 1;
    end if;
  end loop;

  if v_option_count < 2 or v_option_count > 8 then
    raise exception 'status_options must contain between 2 and 8 items.';
  end if;
  if v_default_count <> 1 then
    raise exception 'Exactly one default status option is required.';
  end if;

  update public.honk_activities
  set    activity             = trim(p_activity),
         location             = trim(p_location),
         details              = nullif(trim(coalesce(p_details, '')), ''),
         status_reset_seconds = p_status_reset_seconds
  where  id = p_activity_id;

  update public.honk_activity_status_options
  set    is_active = false,
         is_default = false
  where  activity_id = p_activity_id;

  for v_option in select value from jsonb_array_elements(p_status_options) loop
    v_status_key := trim(v_option ->> 'status_key');
    v_label      := trim(v_option ->> 'label');
    v_sort_order := coalesce((v_option ->> 'sort_order')::integer, 0);
    v_is_default := coalesce((v_option ->> 'is_default')::boolean, false);

    insert into public.honk_activity_status_options (
      activity_id, status_key, label, sort_order, is_default, is_active
    )
    values (p_activity_id, v_status_key, v_label, v_sort_order, v_is_default, true)
    on conflict (activity_id, status_key) do update
      set label      = excluded.label,
          sort_order = excluded.sort_order,
          is_default = excluded.is_default,
          is_active  = true;
  end loop;

  return jsonb_build_object('activity_id', p_activity_id);
end;
$$;
