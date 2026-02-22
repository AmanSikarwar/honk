-- Enable Supabase Realtime (Postgres Changes) for all tables that the
-- Flutter app subscribes to via onPostgresChanges.
-- Without being in the supabase_realtime publication, database changes
-- are never broadcast and the realtime streams never update.

alter publication supabase_realtime
  add table public.honk_activities;

alter publication supabase_realtime
  add table public.honk_activity_participants;

alter publication supabase_realtime
  add table public.honk_participant_statuses;

alter publication supabase_realtime
  add table public.honk_activity_status_options;

alter publication supabase_realtime
  add table public.friendships;
