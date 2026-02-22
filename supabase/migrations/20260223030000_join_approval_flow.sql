-- ============================================================
-- Migration: Join approval flow
-- ============================================================
-- Adds join_status to honk_activity_participants.
-- join_status = 'pending'  → waiting for creator approval
-- join_status = 'active'   → approved / member
-- join_status = 'denied'   → rejected
-- Creator rows are always 'active'.
-- Adds approve_join_request and deny_join_request RPCs.
-- Updates can_access_honk_activity so only 'active' members (+ creator) count.
-- Updates get_honk_activity_effective_statuses to exclude non-active members.
-- Updates get_honk_activity_details to include a pending_participants list for creator.
-- Adds webhook trigger on honk_activity_participants so the edge function can
--   notify the creator of a new join request and the joiner upon approval.
-- ============================================================

-- ── 1. Add join_status column ─────────────────────────────────────────────────

alter table public.honk_activity_participants
  add column if not exists join_status text not null default 'active'
    check (join_status in ('pending', 'active', 'denied'));

-- ── 2. Update can_access_honk_activity (only active members count) ────────────

create or replace function public.can_access_honk_activity(
  p_activity_id uuid,
  p_user_id     uuid
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from   public.honk_activities a
    where  a.id = p_activity_id
      and (
        a.creator_id = p_user_id
        or exists (
          select 1
          from   public.honk_activity_participants p
          where  p.activity_id  = a.id
            and  p.user_id      = p_user_id
            and  p.left_at is null
            and  p.join_status  = 'active'
        )
      )
  );
$$;

-- ── 3. Update RLS on honk_activity_participants ───────────────────────────────
-- Allow a user to always see their own row (needed for pending-state Realtime watch)
-- AND allow active members to see all rows in their honks.

drop policy if exists "honk_activity_participants_select_members" on public.honk_activity_participants;
create policy "honk_activity_participants_select_members"
on public.honk_activity_participants
for select
to authenticated
using (
  user_id = (select auth.uid())
  or public.can_access_honk_activity(activity_id, (select auth.uid()))
);

-- ── 4. Update join_honk_activity_by_code (set pending for non-creators) ───────

create or replace function public.join_honk_activity_by_code(
  p_invite_code text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id      uuid := (select auth.uid());
  v_activity_id  uuid;
  v_creator_id   uuid;
  v_join_status  text;
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

  -- Creators join immediately as active; everyone else needs approval.
  if v_user_id = v_creator_id then
    v_join_status := 'active';
  else
    v_join_status := 'pending';
  end if;

  insert into public.honk_activity_participants (
    activity_id, user_id, role, join_status
  )
  values (
    v_activity_id,
    v_user_id,
    case when v_user_id = v_creator_id then 'creator' else 'participant' end,
    v_join_status
  )
  on conflict (activity_id, user_id) do update
    set left_at     = null,
        role        = excluded.role,
        join_status = case
          -- If previously denied/left and re-joining, go pending again (unless creator).
          when excluded.role = 'creator' then 'active'
          else 'pending'
        end,
        joined_at   = timezone('utc'::text, now());

  return jsonb_build_object(
    'activity_id', v_activity_id,
    'join_status', v_join_status
  );
end;
$$;

-- ── 5. Add approve_join_request RPC ──────────────────────────────────────────

create or replace function public.approve_join_request(
  p_activity_id uuid,
  p_user_id     uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_caller_id uuid := (select auth.uid());
begin
  if v_caller_id is null then
    raise exception 'Authentication required.';
  end if;

  if not exists (
    select 1 from public.honk_activities a
    where  a.id = p_activity_id and a.creator_id = v_caller_id
  ) then
    raise exception 'Only the creator can approve join requests.';
  end if;

  update public.honk_activity_participants
  set    join_status = 'active'
  where  activity_id = p_activity_id
    and  user_id     = p_user_id
    and  join_status = 'pending';

  if not found then
    raise exception 'No pending join request found for that user.';
  end if;

  return jsonb_build_object(
    'activity_id', p_activity_id,
    'user_id',     p_user_id,
    'join_status', 'active'
  );
end;
$$;

-- ── 6. Add deny_join_request RPC ─────────────────────────────────────────────

create or replace function public.deny_join_request(
  p_activity_id uuid,
  p_user_id     uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_caller_id uuid := (select auth.uid());
begin
  if v_caller_id is null then
    raise exception 'Authentication required.';
  end if;

  if not exists (
    select 1 from public.honk_activities a
    where  a.id = p_activity_id and a.creator_id = v_caller_id
  ) then
    raise exception 'Only the creator can deny join requests.';
  end if;

  update public.honk_activity_participants
  set    join_status = 'denied',
         left_at     = timezone('utc'::text, now())
  where  activity_id = p_activity_id
    and  user_id     = p_user_id
    and  join_status = 'pending';

  if not found then
    raise exception 'No pending join request found for that user.';
  end if;

  return jsonb_build_object(
    'activity_id', p_activity_id,
    'user_id',     p_user_id,
    'join_status', 'denied'
  );
end;
$$;

-- ── 7. Update get_honk_activity_effective_statuses (active only) ──────────────

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
    and p.left_at     is null
    and p.join_status = 'active';
$$;

-- ── 8. Update get_honk_activity_details (add pending_participants for creator) ─

create or replace function public.get_honk_activity_details(
  p_activity_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id  uuid := (select auth.uid());
  v_activity record;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if not public.can_access_honk_activity(p_activity_id, v_user_id) then
    raise exception 'Not authorized to access this activity.';
  end if;

  select * into v_activity
  from public.honk_activities a
  where a.id = p_activity_id;

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
            'user_id',              s.user_id,
            'username',             s.username,
            'full_name',            s.full_name,
            'profile_url',          s.profile_url,
            'role',                 s.role,
            'effective_status_key', s.effective_status_key,
            'status_updated_at',    s.status_updated_at,
            'status_expires_at',    s.status_expires_at
          )
          order by s.username asc
        ),
        '[]'::jsonb
      )
      from public.get_honk_activity_effective_statuses(p_activity_id) s
    ),
    -- Only included for creator; empty array otherwise.
    'pending_participants', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'user_id',    pr.id,
            'username',   pr.username,
            'full_name',  pr.full_name,
            'profile_url', pr.profile_url
          )
          order by pr.username asc
        ),
        '[]'::jsonb
      )
      from public.honk_activity_participants p
      join public.profiles pr on pr.id = p.user_id
      where p.activity_id = p_activity_id
        and p.join_status  = 'pending'
        and p.left_at is null
        -- Only the creator can see pending participants.
        and v_activity.creator_id = v_user_id
    )
  );
end;
$$;

-- ── 9. Update set_honk_status (enforce active join_status) ───────────────────

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
    from   public.honk_activity_participants p
    where  p.activity_id  = p_activity_id
      and  p.user_id      = v_user_id
      and  p.left_at is null
      and  p.join_status  = 'active'
  ) then
    raise exception 'Only active participants can set status.';
  end if;

  if not exists (
    select 1
    from   public.honk_activity_status_options o
    where  o.activity_id = p_activity_id
      and  o.status_key  = trim(p_status_key)
      and  o.is_active   = true
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

-- ── 10. Webhook trigger on honk_activity_participants ─────────────────────────
-- Fires on INSERT (new join request) and UPDATE of join_status (approved/denied).

drop trigger if exists honk_participant_join_webhook on public.honk_activity_participants;
create trigger honk_participant_join_webhook
after insert or update of join_status
on public.honk_activity_participants
for each row
execute function public.dispatch_honk_push_webhook();
