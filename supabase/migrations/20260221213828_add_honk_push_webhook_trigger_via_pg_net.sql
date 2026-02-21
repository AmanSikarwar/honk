create extension if not exists pg_net;

create or replace function public.dispatch_honk_push_webhook()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform net.http_post(
    url := 'https://hvjwwumqzfqbdjwamfig.supabase.co/functions/v1/honk-push',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2and3dW1xemZxYmRqd2FtZmlnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2OTEwNzgsImV4cCI6MjA4NzI2NzA3OH0.cF5jDLKQtjIfLwp3Xd5yik3ZYb_r0JwfDlAFD8MHiLo'
    ),
    body := jsonb_build_object(
      'type', TG_OP,
      'table', TG_TABLE_NAME,
      'schema', TG_TABLE_SCHEMA,
      'record', to_jsonb(NEW),
      'old_record', null
    ),
    timeout_milliseconds := 5000
  );

  return NEW;
end;
$$;

drop trigger if exists honk_push_webhook on public.honks;

create trigger honk_push_webhook
after insert on public.honks
for each row
execute function public.dispatch_honk_push_webhook();
