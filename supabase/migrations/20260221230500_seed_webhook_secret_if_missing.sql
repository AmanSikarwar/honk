insert into public.runtime_config (key, value)
values (
  'honk_push_webhook_secret',
  encode(extensions.gen_random_bytes(32), 'hex')
)
on conflict (key) do nothing;
