insert into public.runtime_config (key, value)
select
  'supabase_anon_key',
  current_setting('app.settings.supabase_anon_key', true)
where nullif(current_setting('app.settings.supabase_anon_key', true), '') is not null
on conflict (key) do nothing;

insert into public.runtime_config (key, value)
select
  'honk_push_webhook_secret',
  current_setting('app.settings.honk_push_webhook_secret', true)
where
  nullif(current_setting('app.settings.honk_push_webhook_secret', true), '') is
  not null
on conflict (key) do nothing;

create or replace function public.dispatch_honk_push_webhook()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  anon_key text;
  webhook_secret text;
  request_headers jsonb;
begin
  select c.value
  into anon_key
  from public.runtime_config c
  where c.key = 'supabase_anon_key';

  if anon_key is null or char_length(trim(anon_key)) = 0 then
    anon_key := nullif(current_setting('app.settings.supabase_anon_key', true), '');
  end if;

  select c.value
  into webhook_secret
  from public.runtime_config c
  where c.key = 'honk_push_webhook_secret';

  if webhook_secret is null or char_length(trim(webhook_secret)) = 0 then
    webhook_secret := nullif(current_setting('app.settings.honk_push_webhook_secret', true), '');
  end if;

  if anon_key is null then
    raise warning 'Skipping honk push webhook dispatch due to missing anon key.';
    return NEW;
  end if;

  if webhook_secret is null then
    raise warning 'Skipping honk push webhook dispatch due to missing webhook secret.';
    return NEW;
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
