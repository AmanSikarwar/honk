create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check ((select auth.uid()) = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

drop policy if exists "friendships_select_participants" on public.friendships;
create policy "friendships_select_participants"
on public.friendships
for select
to authenticated
using ((select auth.uid()) = user_id or (select auth.uid()) = friend_id);

drop policy if exists "friendships_insert_participants" on public.friendships;
create policy "friendships_insert_participants"
on public.friendships
for insert
to authenticated
with check ((select auth.uid()) = user_id or (select auth.uid()) = friend_id);

drop policy if exists "friendships_update_participants" on public.friendships;
create policy "friendships_update_participants"
on public.friendships
for update
to authenticated
using ((select auth.uid()) = user_id or (select auth.uid()) = friend_id)
with check ((select auth.uid()) = user_id or (select auth.uid()) = friend_id);

drop policy if exists "friendships_delete_participants" on public.friendships;
create policy "friendships_delete_participants"
on public.friendships
for delete
to authenticated
using ((select auth.uid()) = user_id or (select auth.uid()) = friend_id);

drop policy if exists "honks_select_self_or_friends" on public.honks;
create policy "honks_select_self_or_friends"
on public.honks
for select
to authenticated
using (
  user_id = (select auth.uid())
  or exists (
    select 1
    from public.friendships f
    where f.status = 'accepted'
      and (
        (f.user_id = (select auth.uid()) and f.friend_id = honks.user_id)
        or (f.friend_id = (select auth.uid()) and f.user_id = honks.user_id)
      )
  )
);

drop policy if exists "honks_insert_own" on public.honks;
create policy "honks_insert_own"
on public.honks
for insert
to authenticated
with check (user_id = (select auth.uid()));

drop policy if exists "honks_update_own" on public.honks;
create policy "honks_update_own"
on public.honks
for update
to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

drop policy if exists "honks_delete_own" on public.honks;
create policy "honks_delete_own"
on public.honks
for delete
to authenticated
using (user_id = (select auth.uid()));
