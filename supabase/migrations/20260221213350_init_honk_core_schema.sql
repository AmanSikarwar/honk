create extension if not exists pgcrypto with schema extensions;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null check (char_length(trim(username)) >= 2),
  fcm_token text,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.friendships (
  user_id uuid not null references public.profiles (id) on delete cascade,
  friend_id uuid not null references public.profiles (id) on delete cascade,
  status text not null default 'accepted' check (status in ('pending', 'accepted', 'blocked')),
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  primary key (user_id, friend_id),
  constraint friendships_no_self check (user_id <> friend_id)
);

create table if not exists public.honks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  location text not null check (char_length(trim(location)) > 0),
  status text not null,
  created_at timestamptz not null default timezone('utc'::text, now()),
  expires_at timestamptz not null,
  constraint honks_expiry_after_create check (expires_at > created_at)
);

create index if not exists idx_profiles_username on public.profiles (username);
create index if not exists idx_friendships_user_status on public.friendships (user_id, status);
create index if not exists idx_friendships_friend_status on public.friendships (friend_id, status);
create index if not exists idx_honks_user_created_at on public.honks (user_id, created_at desc);
create index if not exists idx_honks_expires_at on public.honks (expires_at);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  generated_username text;
begin
  generated_username := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'username'), ''),
    'user_' || left(new.id::text, 8)
  );

  insert into public.profiles (id, username)
  values (new.id, generated_username)
  on conflict (id) do update
  set username = excluded.username;

  return new;
end;
$$;

drop trigger if exists trg_profiles_set_updated_at on public.profiles;
create trigger trg_profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

drop trigger if exists trg_friendships_set_updated_at on public.friendships;
create trigger trg_friendships_set_updated_at
before update on public.friendships
for each row
execute function public.set_updated_at();

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_auth_user();

alter table public.profiles enable row level security;
alter table public.friendships enable row level security;
alter table public.honks enable row level security;

drop policy if exists "profiles_select_authenticated" on public.profiles;
create policy "profiles_select_authenticated"
on public.profiles
for select
to authenticated
using (true);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "friendships_select_participants" on public.friendships;
create policy "friendships_select_participants"
on public.friendships
for select
to authenticated
using (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists "friendships_insert_participants" on public.friendships;
create policy "friendships_insert_participants"
on public.friendships
for insert
to authenticated
with check (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists "friendships_update_participants" on public.friendships;
create policy "friendships_update_participants"
on public.friendships
for update
to authenticated
using (auth.uid() = user_id or auth.uid() = friend_id)
with check (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists "friendships_delete_participants" on public.friendships;
create policy "friendships_delete_participants"
on public.friendships
for delete
to authenticated
using (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists "honks_select_self_or_friends" on public.honks;
create policy "honks_select_self_or_friends"
on public.honks
for select
to authenticated
using (
  user_id = auth.uid()
  or exists (
    select 1
    from public.friendships f
    where f.status = 'accepted'
      and (
        (f.user_id = auth.uid() and f.friend_id = honks.user_id)
        or (f.friend_id = auth.uid() and f.user_id = honks.user_id)
      )
  )
);

drop policy if exists "honks_insert_own" on public.honks;
create policy "honks_insert_own"
on public.honks
for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "honks_update_own" on public.honks;
create policy "honks_update_own"
on public.honks
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "honks_delete_own" on public.honks;
create policy "honks_delete_own"
on public.honks
for delete
to authenticated
using (user_id = auth.uid());
