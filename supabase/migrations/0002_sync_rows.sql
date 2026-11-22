-- Sync between phones (run once in Supabase → SQL Editor; running it again
-- is harmless).
--
-- Every synced record of a shop is one row here: the table it belongs to,
-- its id (a random text id made on the phone), and the record as JSON.
-- Each insert or update gets the next number from a sequence (`seq`), so a
-- phone asks "everything of my shop after number N" to catch up.

create table if not exists public.sync_rows (
  shop_id uuid not null references public.shops (id) on delete cascade,
  tbl text not null,
  row_id text not null,
  data jsonb not null,
  deleted boolean not null default false,
  device_id uuid,
  seq bigint not null default 0,
  updated_at timestamptz not null default now(),
  primary key (shop_id, tbl, row_id)
);

create sequence if not exists public.sync_rows_seq;

-- Number every insert and update, server-side (phones can't fake order).
create or replace function public.sync_rows_stamp()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.seq := nextval('public.sync_rows_seq');
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists sync_rows_stamp on public.sync_rows;
create trigger sync_rows_stamp
  before insert or update on public.sync_rows
  for each row execute function public.sync_rows_stamp();

create index if not exists sync_rows_pull on public.sync_rows (shop_id, seq);

-- Only members of a shop can read or write its rows.
alter table public.sync_rows enable row level security;

drop policy if exists "sync rows: members read" on public.sync_rows;
create policy "sync rows: members read" on public.sync_rows
  for select to authenticated
  using (public.is_member(shop_id));

drop policy if exists "sync rows: members add" on public.sync_rows;
create policy "sync rows: members add" on public.sync_rows
  for insert to authenticated
  with check (public.is_member(shop_id));

drop policy if exists "sync rows: members change" on public.sync_rows;
create policy "sync rows: members change" on public.sync_rows
  for update to authenticated
  using (public.is_member(shop_id))
  with check (public.is_member(shop_id));

grant select, insert, update on public.sync_rows to authenticated;
grant usage on sequence public.sync_rows_seq to authenticated;
