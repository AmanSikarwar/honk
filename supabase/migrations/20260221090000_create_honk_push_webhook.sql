-- Triggers Supabase Edge Function `honk-push` whenever a new honk is inserted.
-- Replace placeholders before running on your project.

create trigger "honk_push_webhook"
after insert
on "public"."honks"
for each row
execute function "supabase_functions"."http_request"(
  'https://YOUR_PROJECT_REF.supabase.co/functions/v1/honk-push',
  'POST',
  '{"Content-Type":"application/json","Authorization":"Bearer YOUR_SERVICE_ROLE_KEY"}',
  '{}',
  '5000'
);
