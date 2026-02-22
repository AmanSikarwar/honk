-- ============================================================
-- Migration: Remove friendships — anyone with an invite code can join
-- ============================================================
-- Drops the friendships table and are_users_accepted_friends function.
-- Removes p_participant_ids from create_honk_activity.
-- Removes the friendship gate from join_honk_activity_by_code.
-- ============================================================

-- ── 1. Update create_honk_activity (remove p_participant_ids + friend check) ──

create or replace function public.create_honk_activity(
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
  v_activity_id   uuid;
  v_invite_code   text;
  v_option_count  integer := 0;
  v_default_count integer := 0;
  v_option        jsonb;
  v_status_key    text;
  v_label         text;
  v_sort_order    integer;
  v_is_default    boolean;
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

  return jsonb_build_object(
    'activity_id', v_activity_id,
    'invite_code', v_invite_code
  );
end;
$$;

-- ── 2. Update join_honk_activity_by_code (remove friendship gate) ─────────────

create or replace function public.join_honk_activity_by_code(
  p_invite_code text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id    uuid := (select auth.uid());
  v_activity_id uuid;
  v_creator_id  uuid;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  select id, creator_id
  into   v_activity_id, v_creator_id
  from   public.honk_activities
  where  invite_code = trim(p_invite_code);

  if v_activity_id is null then
    raise exception 'Invalid invite code.';
  end if;

  insert into public.honk_activity_participants (activity_id, user_id, role)
  values (
    v_activity_id,
    v_user_id,
    case when v_user_id = v_creator_id then 'creator' else 'participant' end
  )
  on conflict (activity_id, user_id) do update
    set left_at   = null,
        role      = excluded.role,
        joined_at = timezone('utc'::text, now());

  return jsonb_build_object('activity_id', v_activity_id);
end;
$$;

-- ── 3. Drop friendships table and helper function ─────────────────────────────

drop function if exists public.are_users_accepted_friends(uuid, uuid);

drop table if exists public.friendships cascade;
