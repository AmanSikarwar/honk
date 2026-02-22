create table if not exists public.honk_activities (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid not null references public.profiles (id) on delete cascade,
  activity text not null check (char_length(trim(activity)) > 0),
  location text not null check (char_length(trim(location)) > 0),
  details text,
  starts_at timestamptz not null,
  recurrence_rrule text,
  recurrence_timezone text not null check (char_length(trim(recurrence_timezone)) > 0),
  status_reset_seconds integer not null check (status_reset_seconds > 0),
  invite_code text not null unique,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.honk_activity_status_options (
  activity_id uuid not null references public.honk_activities (id) on delete cascade,
  status_key text not null check (status_key ~ '^[a-z0-9_]+$'),
  label text not null check (char_length(trim(label)) > 0),
  sort_order integer not null default 0,
  is_default boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  primary key (activity_id, status_key)
);

create unique index if not exists idx_honk_status_options_one_default
on public.honk_activity_status_options (activity_id)
where (is_default = true and is_active = true);

create table if not exists public.honk_activity_participants (
  activity_id uuid not null references public.honk_activities (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  role text not null check (role in ('creator', 'participant')),
  joined_at timestamptz not null default timezone('utc'::text, now()),
  left_at timestamptz,
  primary key (activity_id, user_id)
);

create table if not exists public.honk_participant_statuses (
  activity_id uuid not null references public.honk_activities (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  occurrence_start timestamptz not null,
  status_key text not null,
  updated_at timestamptz not null default timezone('utc'::text, now()),
  expires_at timestamptz not null,
  primary key (activity_id, user_id, occurrence_start),
  constraint honk_participant_statuses_expiry_after_update
    check (expires_at > updated_at)
);

alter table public.honk_participant_statuses
drop constraint if exists honk_participant_statuses_status_fk;

alter table public.honk_participant_statuses
add constraint honk_participant_statuses_status_fk
foreign key (activity_id, status_key)
references public.honk_activity_status_options (activity_id, status_key)
on delete restrict;

create index if not exists idx_honk_activities_creator
on public.honk_activities (creator_id, updated_at desc);

create index if not exists idx_honk_activities_invite_code
on public.honk_activities (invite_code);

create index if not exists idx_honk_activity_participants_user_active
on public.honk_activity_participants (user_id, activity_id)
where left_at is null;

create index if not exists idx_honk_participant_statuses_activity_occurrence
on public.honk_participant_statuses (activity_id, occurrence_start, updated_at desc);

drop trigger if exists trg_honk_activities_set_updated_at on public.honk_activities;
create trigger trg_honk_activities_set_updated_at
before update on public.honk_activities
for each row execute function public.set_updated_at();

drop trigger if exists trg_honk_activity_status_options_set_updated_at on public.honk_activity_status_options;
create trigger trg_honk_activity_status_options_set_updated_at
before update on public.honk_activity_status_options
for each row execute function public.set_updated_at();

create or replace function public.generate_honk_invite_code()
returns text
language sql
as $$
  select encode(extensions.gen_random_bytes(6), 'hex');
$$;

create or replace function public.are_users_accepted_friends(
  p_user_a uuid,
  p_user_b uuid
)
returns boolean
language sql
stable
set search_path = public
as $$
  select exists (
    select 1
    from public.friendships f
    where f.status = 'accepted'
      and (
        (f.user_id = p_user_a and f.friend_id = p_user_b)
        or (f.user_id = p_user_b and f.friend_id = p_user_a)
      )
  );
$$;

create or replace function public.can_access_honk_activity(
  p_activity_id uuid,
  p_user_id uuid
)
returns boolean
language sql
stable
set search_path = public
as $$
  select exists (
    select 1
    from public.honk_activities a
    where a.id = p_activity_id
      and (
        a.creator_id = p_user_id
        or exists (
          select 1
          from public.honk_activity_participants p
          where p.activity_id = a.id
            and p.user_id = p_user_id
            and p.left_at is null
        )
      )
  );
$$;

alter table public.honk_activities enable row level security;
alter table public.honk_activity_status_options enable row level security;
alter table public.honk_activity_participants enable row level security;
alter table public.honk_participant_statuses enable row level security;

drop policy if exists "honk_activities_select_members" on public.honk_activities;
create policy "honk_activities_select_members"
on public.honk_activities
for select
to authenticated
using (public.can_access_honk_activity(id, (select auth.uid())));

drop policy if exists "honk_activities_insert_creator" on public.honk_activities;
create policy "honk_activities_insert_creator"
on public.honk_activities
for insert
to authenticated
with check (creator_id = (select auth.uid()));

drop policy if exists "honk_activities_update_creator" on public.honk_activities;
create policy "honk_activities_update_creator"
on public.honk_activities
for update
to authenticated
using (creator_id = (select auth.uid()))
with check (creator_id = (select auth.uid()));

drop policy if exists "honk_activities_delete_creator" on public.honk_activities;
create policy "honk_activities_delete_creator"
on public.honk_activities
for delete
to authenticated
using (creator_id = (select auth.uid()));

drop policy if exists "honk_activity_status_options_select_members" on public.honk_activity_status_options;
create policy "honk_activity_status_options_select_members"
on public.honk_activity_status_options
for select
to authenticated
using (public.can_access_honk_activity(activity_id, (select auth.uid())));

drop policy if exists "honk_activity_status_options_manage_creator" on public.honk_activity_status_options;
create policy "honk_activity_status_options_manage_creator"
on public.honk_activity_status_options
for all
to authenticated
using (
  exists (
    select 1
    from public.honk_activities a
    where a.id = activity_id
      and a.creator_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1
    from public.honk_activities a
    where a.id = activity_id
      and a.creator_id = (select auth.uid())
  )
);

drop policy if exists "honk_activity_participants_select_members" on public.honk_activity_participants;
create policy "honk_activity_participants_select_members"
on public.honk_activity_participants
for select
to authenticated
using (public.can_access_honk_activity(activity_id, (select auth.uid())));

drop policy if exists "honk_participant_statuses_select_members" on public.honk_participant_statuses;
create policy "honk_participant_statuses_select_members"
on public.honk_participant_statuses
for select
to authenticated
using (public.can_access_honk_activity(activity_id, (select auth.uid())));

create or replace function public.create_honk_activity(
  p_activity text,
  p_location text,
  p_details text,
  p_starts_at timestamptz,
  p_recurrence_rrule text,
  p_recurrence_timezone text,
  p_status_reset_seconds integer,
  p_status_options jsonb,
  p_participant_ids uuid[] default '{}'::uuid[]
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_activity_id uuid;
  v_invite_code text;
  v_option_count integer := 0;
  v_default_count integer := 0;
  v_option jsonb;
  v_status_key text;
  v_label text;
  v_sort_order integer;
  v_is_default boolean;
  v_participant_id uuid;
  v_attempt integer := 0;
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

  if p_starts_at is null then
    raise exception 'starts_at is required.';
  end if;

  if p_recurrence_timezone is null or char_length(trim(p_recurrence_timezone)) = 0 then
    raise exception 'recurrence_timezone is required.';
  end if;

  if p_status_reset_seconds is null or p_status_reset_seconds <= 0 then
    raise exception 'status_reset_seconds must be > 0.';
  end if;

  if p_status_options is null or jsonb_typeof(p_status_options) <> 'array' then
    raise exception 'status_options must be a JSON array.';
  end if;

  for v_option in
    select value
    from jsonb_array_elements(p_status_options)
  loop
    v_option_count := v_option_count + 1;
    v_status_key := trim(coalesce(v_option ->> 'status_key', ''));
    v_label := trim(coalesce(v_option ->> 'label', ''));
    v_is_default := coalesce((v_option ->> 'is_default')::boolean, false);

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
        creator_id,
        activity,
        location,
        details,
        starts_at,
        recurrence_rrule,
        recurrence_timezone,
        status_reset_seconds,
        invite_code
      )
      values (
        v_user_id,
        trim(p_activity),
        trim(p_location),
        nullif(trim(coalesce(p_details, '')), ''),
        p_starts_at,
        nullif(trim(coalesce(p_recurrence_rrule, '')), ''),
        trim(p_recurrence_timezone),
        p_status_reset_seconds,
        v_invite_code
      )
      returning id into v_activity_id;
    exception
      when unique_violation then
        v_activity_id := null;
    end;
  end loop;

  for v_option in
    select value
    from jsonb_array_elements(p_status_options)
  loop
    v_status_key := trim(v_option ->> 'status_key');
    v_label := trim(v_option ->> 'label');
    v_sort_order := coalesce((v_option ->> 'sort_order')::integer, 0);
    v_is_default := coalesce((v_option ->> 'is_default')::boolean, false);

    insert into public.honk_activity_status_options (
      activity_id,
      status_key,
      label,
      sort_order,
      is_default,
      is_active
    )
    values (
      v_activity_id,
      v_status_key,
      v_label,
      v_sort_order,
      v_is_default,
      true
    );
  end loop;

  insert into public.honk_activity_participants (activity_id, user_id, role)
  values (v_activity_id, v_user_id, 'creator')
  on conflict (activity_id, user_id) do update
  set role = excluded.role, joined_at = timezone('utc'::text, now()), left_at = null;

  foreach v_participant_id in array p_participant_ids
  loop
    if v_participant_id = v_user_id then
      continue;
    end if;

    if not public.are_users_accepted_friends(v_user_id, v_participant_id) then
      raise exception 'Participant % is not an accepted friend.', v_participant_id;
    end if;

    insert into public.honk_activity_participants (activity_id, user_id, role)
    values (v_activity_id, v_participant_id, 'participant')
    on conflict (activity_id, user_id) do update
    set role = excluded.role, joined_at = timezone('utc'::text, now()), left_at = null;
  end loop;

  return jsonb_build_object(
    'activity_id', v_activity_id,
    'invite_code', v_invite_code
  );
end;
$$;

create or replace function public.update_honk_activity(
  p_activity_id uuid,
  p_activity text,
  p_location text,
  p_details text,
  p_starts_at timestamptz,
  p_recurrence_rrule text,
  p_recurrence_timezone text,
  p_status_reset_seconds integer,
  p_status_options jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_option jsonb;
  v_option_count integer := 0;
  v_default_count integer := 0;
  v_status_key text;
  v_label text;
  v_sort_order integer;
  v_is_default boolean;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if not exists (
    select 1
    from public.honk_activities a
    where a.id = p_activity_id
      and a.creator_id = v_user_id
  ) then
    raise exception 'Only creator can update this activity.';
  end if;

  if p_activity is null or char_length(trim(p_activity)) = 0 then
    raise exception 'Activity is required.';
  end if;

  if p_location is null or char_length(trim(p_location)) = 0 then
    raise exception 'Location is required.';
  end if;

  if p_starts_at is null then
    raise exception 'starts_at is required.';
  end if;

  if p_recurrence_timezone is null or char_length(trim(p_recurrence_timezone)) = 0 then
    raise exception 'recurrence_timezone is required.';
  end if;

  if p_status_reset_seconds is null or p_status_reset_seconds <= 0 then
    raise exception 'status_reset_seconds must be > 0.';
  end if;

  if p_status_options is null or jsonb_typeof(p_status_options) <> 'array' then
    raise exception 'status_options must be a JSON array.';
  end if;

  for v_option in
    select value
    from jsonb_array_elements(p_status_options)
  loop
    v_option_count := v_option_count + 1;
    v_status_key := trim(coalesce(v_option ->> 'status_key', ''));
    v_label := trim(coalesce(v_option ->> 'label', ''));
    v_is_default := coalesce((v_option ->> 'is_default')::boolean, false);

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
  set activity = trim(p_activity),
      location = trim(p_location),
      details = nullif(trim(coalesce(p_details, '')), ''),
      starts_at = p_starts_at,
      recurrence_rrule = nullif(trim(coalesce(p_recurrence_rrule, '')), ''),
      recurrence_timezone = trim(p_recurrence_timezone),
      status_reset_seconds = p_status_reset_seconds
  where id = p_activity_id;

  update public.honk_activity_status_options
  set is_active = false,
      is_default = false
  where activity_id = p_activity_id;

  for v_option in
    select value
    from jsonb_array_elements(p_status_options)
  loop
    v_status_key := trim(v_option ->> 'status_key');
    v_label := trim(v_option ->> 'label');
    v_sort_order := coalesce((v_option ->> 'sort_order')::integer, 0);
    v_is_default := coalesce((v_option ->> 'is_default')::boolean, false);

    insert into public.honk_activity_status_options (
      activity_id,
      status_key,
      label,
      sort_order,
      is_default,
      is_active
    )
    values (
      p_activity_id,
      v_status_key,
      v_label,
      v_sort_order,
      v_is_default,
      true
    )
    on conflict (activity_id, status_key)
    do update set
      label = excluded.label,
      sort_order = excluded.sort_order,
      is_default = excluded.is_default,
      is_active = true;
  end loop;

  return jsonb_build_object('activity_id', p_activity_id);
end;
$$;

create or replace function public.rotate_honk_invite_code(
  p_activity_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_new_code text;
  v_updated integer := 0;
  v_attempt integer := 0;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  if not exists (
    select 1
    from public.honk_activities a
    where a.id = p_activity_id
      and a.creator_id = v_user_id
  ) then
    raise exception 'Only creator can rotate invite code.';
  end if;

  while v_updated = 0 loop
    v_attempt := v_attempt + 1;
    if v_attempt > 10 then
      raise exception 'Unable to rotate invite code.';
    end if;

    v_new_code := public.generate_honk_invite_code();
    begin
      update public.honk_activities
      set invite_code = v_new_code
      where id = p_activity_id
        and creator_id = v_user_id;

      get diagnostics v_updated = row_count;
    exception
      when unique_violation then
        v_updated := 0;
    end;
  end loop;

  return jsonb_build_object(
    'activity_id', p_activity_id,
    'invite_code', v_new_code
  );
end;
$$;

create or replace function public.join_honk_activity_by_code(
  p_invite_code text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_activity_id uuid;
  v_creator_id uuid;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  select id, creator_id
  into v_activity_id, v_creator_id
  from public.honk_activities
  where invite_code = trim(p_invite_code);

  if v_activity_id is null then
    raise exception 'Invalid invite code.';
  end if;

  if v_user_id <> v_creator_id and not public.are_users_accepted_friends(v_user_id, v_creator_id) then
    raise exception 'Only accepted friends can join this activity.';
  end if;

  insert into public.honk_activity_participants (activity_id, user_id, role)
  values (
    v_activity_id,
    v_user_id,
    case when v_user_id = v_creator_id then 'creator' else 'participant' end
  )
  on conflict (activity_id, user_id) do update
  set left_at = null,
      role = excluded.role,
      joined_at = timezone('utc'::text, now());

  return jsonb_build_object('activity_id', v_activity_id);
end;
$$;

create or replace function public.leave_honk_activity(
  p_activity_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_updated integer := 0;
begin
  if v_user_id is null then
    raise exception 'Authentication required.';
  end if;

  update public.honk_activity_participants
  set left_at = timezone('utc'::text, now())
  where activity_id = p_activity_id
    and user_id = v_user_id
    and role <> 'creator'
    and left_at is null;

  get diagnostics v_updated = row_count;
  if v_updated = 0 then
    raise exception 'Unable to leave activity.';
  end if;

  return jsonb_build_object('activity_id', p_activity_id);
end;
$$;

create or replace function public.set_honk_status(
  p_activity_id uuid,
  p_status_key text,
  p_occurrence_start timestamptz default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_occurrence_start timestamptz;
  v_status_reset_seconds integer;
  v_expires_at timestamptz;
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
      and p.user_id = v_user_id
      and p.left_at is null
  ) then
    raise exception 'Only active participants can set status.';
  end if;

  if not exists (
    select 1
    from public.honk_activity_status_options o
    where o.activity_id = p_activity_id
      and o.status_key = trim(p_status_key)
      and o.is_active = true
  ) then
    raise exception 'Invalid status key for this activity.';
  end if;

  select a.status_reset_seconds, a.starts_at
  into v_status_reset_seconds, v_occurrence_start
  from public.honk_activities a
  where a.id = p_activity_id;

  if p_occurrence_start is not null then
    v_occurrence_start := p_occurrence_start;
  end if;

  if v_occurrence_start is null then
    raise exception 'occurrence_start could not be resolved.';
  end if;

  v_expires_at := timezone('utc'::text, now()) + make_interval(secs => v_status_reset_seconds);

  insert into public.honk_participant_statuses (
    activity_id,
    user_id,
    occurrence_start,
    status_key,
    updated_at,
    expires_at
  )
  values (
    p_activity_id,
    v_user_id,
    v_occurrence_start,
    trim(p_status_key),
    timezone('utc'::text, now()),
    v_expires_at
  )
  on conflict (activity_id, user_id, occurrence_start) do update
  set status_key = excluded.status_key,
      updated_at = excluded.updated_at,
      expires_at = excluded.expires_at;

  return jsonb_build_object(
    'activity_id', p_activity_id,
    'user_id', v_user_id,
    'occurrence_start', v_occurrence_start,
    'status_key', trim(p_status_key),
    'expires_at', v_expires_at
  );
end;
$$;

create or replace function public.get_honk_activity_effective_statuses(
  p_activity_id uuid,
  p_occurrence_start timestamptz
)
returns table (
  user_id uuid,
  username text,
  role text,
  effective_status_key text,
  status_updated_at timestamptz,
  status_expires_at timestamptz
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
    p.role,
    case
      when s.expires_at is not null and s.expires_at > timezone('utc'::text, now()) then s.status_key
      else (select d.status_key from default_status d)
    end as effective_status_key,
    s.updated_at as status_updated_at,
    s.expires_at as status_expires_at
  from public.honk_activity_participants p
  join public.profiles pr on pr.id = p.user_id
  left join public.honk_participant_statuses s
    on s.activity_id = p.activity_id
   and s.user_id = p.user_id
   and s.occurrence_start = p_occurrence_start
  where p.activity_id = p_activity_id
    and p.left_at is null;
$$;

create or replace function public.get_honk_activity_details(
  p_activity_id uuid,
  p_occurrence_start timestamptz default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_activity record;
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
    'activity', to_jsonb(v_activity),
    'occurrence_start', v_occurrence_start,
    'status_options', (
      select coalesce(jsonb_agg(to_jsonb(o) order by o.sort_order asc, o.status_key asc), '[]'::jsonb)
      from public.honk_activity_status_options o
      where o.activity_id = p_activity_id
        and o.is_active = true
    ),
    'participants', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'user_id', s.user_id,
            'username', s.username,
            'role', s.role,
            'effective_status_key', s.effective_status_key,
            'status_updated_at', s.status_updated_at,
            'status_expires_at', s.status_expires_at
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

drop trigger if exists honk_push_webhook on public.honks;
drop trigger if exists honk_activity_created_webhook on public.honk_activities;
drop trigger if exists honk_participant_status_webhook on public.honk_participant_statuses;

create trigger honk_activity_created_webhook
after insert on public.honk_activities
for each row
execute function public.dispatch_honk_push_webhook();

create trigger honk_participant_status_webhook
after insert or update of status_key, expires_at on public.honk_participant_statuses
for each row
execute function public.dispatch_honk_push_webhook();

truncate table public.honks;
