-- Required once per environment:
-- alter database postgres set app.settings.supabase_anon_key = '<SUPABASE_ANON_KEY>';
-- alter database postgres set app.settings.honk_push_webhook_secret = '<RANDOM_WEBHOOK_SECRET>';
create or replace function public.dispatch_honk_push_webhook()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  anon_key text := nullif(
    current_setting('app.settings.supabase_anon_key', true),
    ''
  );
  webhook_secret text := nullif(
    current_setting('app.settings.honk_push_webhook_secret', true),
    ''
  );
  request_headers jsonb;
begin
  if anon_key is null then
    raise exception 'Missing app.settings.supabase_anon_key database setting.';
  end if;

  if webhook_secret is null then
    raise exception 'Missing app.settings.honk_push_webhook_secret database setting.';
  end if;

  request_headers := jsonb_build_object(
    'Content-Type', 'application/json',
    'Authorization', format('Bearer %s', anon_key),
    'x-honk-webhook-secret', webhook_secret
  );

  perform net.http_post(
    url := 'https://hvjwwumqzfqbdjwamfig.supabase.co/functions/v1/honk-push',
    headers := request_headers,
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
