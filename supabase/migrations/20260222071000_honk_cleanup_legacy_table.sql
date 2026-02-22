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

drop table if exists public.honks cascade;
