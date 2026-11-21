-- Shop App · Phase 6, stage 1: shops, who belongs to them, and their phones.
-- Paste into Supabase → SQL Editor → New query → Run. Safe to run twice.

-- A shop (one business). Data tables added later all carry shop_id.
create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) > 0),
  owner_id uuid not null default auth.uid() references auth.users (id),
  created_at timestamptz not null default now()
);

-- Who can use a shop's data: the owner, and later staff.
create table if not exists public.shop_members (
  shop_id uuid not null references public.shops (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role text not null default 'owner' check (role in ('owner', 'staff')),
  created_at timestamptz not null default now(),
  primary key (shop_id, user_id)
);

-- Each phone of a shop, with its own bill series letter (A, B, C…), so
-- phones billing offline never produce the same invoice number.
create table if not exists public.devices (
  id uuid primary key,
  shop_id uuid not null references public.shops (id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users (id),
  series text not null check (series ~ '^[A-Z]{1,2}$'),
  created_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  unique (shop_id, series)
);

-- Is the signed-in user a member of [shop]? Used by every access rule.
create or replace function public.is_member(shop uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.shop_members m
    where m.shop_id = shop and m.user_id = auth.uid()
  );
$$;

-- Access rules: you only ever see shops you belong to.
alter table public.shops enable row level security;
alter table public.shop_members enable row level security;
alter table public.devices enable row level security;

drop policy if exists "members read their shops" on public.shops;
create policy "members read their shops" on public.shops
  for select to authenticated using (public.is_member(id));

drop policy if exists "owners rename their shops" on public.shops;
create policy "owners rename their shops" on public.shops
  for update to authenticated
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "members see who else is in the shop" on public.shop_members;
create policy "members see who else is in the shop" on public.shop_members
  for select to authenticated using (public.is_member(shop_id));

drop policy if exists "members see the shop's phones" on public.devices;
create policy "members see the shop's phones" on public.devices
  for select to authenticated using (public.is_member(shop_id));

-- Creating a shop and joining a phone go through these functions only.
create or replace function public.create_shop(p_name text)
returns public.shops
language plpgsql
security definer
set search_path = ''
as $$
declare
  s public.shops;
begin
  if auth.uid() is null then
    raise exception 'Sign in first';
  end if;
  insert into public.shops (name, owner_id)
    values (trim(p_name), auth.uid())
    returning * into s;
  insert into public.shop_members (shop_id, user_id, role)
    values (s.id, auth.uid(), 'owner');
  return s;
end;
$$;

-- Joins a phone to a shop and returns its series letter. Asking again
-- from the same phone returns the same letter.
create or replace function public.link_device(p_shop uuid, p_device uuid)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  existing text;
  used int;
  letter text;
begin
  if not public.is_member(p_shop) then
    raise exception 'Not a member of this shop';
  end if;
  select series into existing from public.devices
    where id = p_device and shop_id = p_shop;
  if existing is not null then
    update public.devices set last_seen_at = now() where id = p_device;
    return existing;
  end if;
  -- One phone at a time per shop, so two phones can't take the same letter.
  perform 1 from public.shops where id = p_shop for update;
  select count(*) into used from public.devices where shop_id = p_shop;
  letter := case
    when used < 26 then chr(65 + used)
    else chr(65 + used / 26 - 1) || chr(65 + used % 26)
  end;
  insert into public.devices (id, shop_id, user_id, series)
    values (p_device, p_shop, auth.uid(), letter);
  return letter;
end;
$$;

-- "Grant API access to new tables automatically" is off: grant explicitly.
grant select, update on public.shops to authenticated;
grant select on public.shop_members to authenticated;
grant select on public.devices to authenticated;
revoke execute on function public.create_shop(text) from public, anon;
revoke execute on function public.link_device(uuid, uuid) from public, anon;
revoke execute on function public.is_member(uuid) from public, anon;
grant execute on function public.create_shop(text) to authenticated;
grant execute on function public.link_device(uuid, uuid) to authenticated;
grant execute on function public.is_member(uuid) to authenticated;
