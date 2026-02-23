-- Drop the legacy set_honk_status overload that had an optional p_occurrence_start
-- parameter. The newer (uuid, text) version from 20260223010000 already exists, but
-- Postgres keeps both signatures causing an "ambiguous function" error when calling
-- via named parameters. Dropping the legacy signature resolves the ambiguity.

drop function if exists public.set_honk_status(
  p_activity_id      uuid,
  p_status_key       text,
  p_occurrence_start timestamptz
);
