create table if not exists public.runtime_config (
  key text primary key,
  value text not null,
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create or replace function public.set_runtime_config_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

drop trigger if exists trg_runtime_config_set_updated_at on public.runtime_config;
create trigger trg_runtime_config_set_updated_at
before update on public.runtime_config
for each row
execute function public.set_runtime_config_updated_at();

alter table public.runtime_config enable row level security;

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

  select c.value
  into webhook_secret
  from public.runtime_config c
  where c.key = 'honk_push_webhook_secret';

  if anon_key is null then
    raise exception 'Missing runtime_config.supabase_anon_key value.';
  end if;

  if webhook_secret is null then
    raise exception 'Missing runtime_config.honk_push_webhook_secret value.';
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
