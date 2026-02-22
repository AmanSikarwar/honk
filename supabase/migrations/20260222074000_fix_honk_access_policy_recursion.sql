create or replace function public.can_access_honk_activity(
  p_activity_id uuid,
  p_user_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.honk_activities a
    where a.id = p_activity_id
      and (
        a.creator_id = p_user_id
        or exists (
          select 1
          from public.honk_activity_participants p
          where p.activity_id = a.id
            and p.user_id = p_user_id
            and p.left_at is null
        )
      )
  );
$$;
