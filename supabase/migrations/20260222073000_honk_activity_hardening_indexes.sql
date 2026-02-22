create or replace function public.generate_honk_invite_code()
returns text
language sql
stable
set search_path = public, extensions
as $$
  select encode(extensions.gen_random_bytes(6), 'hex');
$$;

create index if not exists idx_honk_participant_statuses_user_id
on public.honk_participant_statuses (user_id);

create index if not exists idx_honk_participant_statuses_activity_status_key
on public.honk_participant_statuses (activity_id, status_key);
