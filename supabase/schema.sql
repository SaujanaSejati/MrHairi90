-- IlmuQuest starter schema for Supabase
-- Review and test in a new project before using in production.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Pemain',
  created_at timestamptz not null default now()
);

create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  icon_key text not null default 'compass',
  sort_order integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.missions (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  title text not null,
  description text not null default '',
  mission_type text not null default 'quiz' check (mission_type in ('quiz','simulation')),
  xp_reward integer not null default 0 check (xp_reward >= 0),
  sort_order integer not null default 0,
  status text not null default 'draft' check (status in ('draft','published','archived')),
  created_at timestamptz not null default now()
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  mission_id uuid not null references public.missions(id) on delete cascade,
  prompt text not null,
  explanation text not null default '',
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.question_options (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.questions(id) on delete cascade,
  option_key text not null,
  option_text text not null,
  sort_order integer not null default 0,
  unique(question_id, option_key)
);

-- Keep answer keys private: never expose correct answers to normal app clients.
create table if not exists public.question_answer_keys (
  question_id uuid primary key references public.questions(id) on delete cascade,
  correct_option_key text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.player_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  mission_id uuid not null references public.missions(id) on delete cascade,
  best_score integer not null default 0 check (best_score >= 0),
  xp_earned integer not null default 0 check (xp_earned >= 0),
  completed_at timestamptz,
  primary key (user_id, mission_id)
);

create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select coalesce((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin', false);
$$;

alter table public.profiles enable row level security;
alter table public.subjects enable row level security;
alter table public.missions enable row level security;
alter table public.questions enable row level security;
alter table public.question_options enable row level security;
alter table public.question_answer_keys enable row level security;
alter table public.player_progress enable row level security;

create policy "profiles select own or admin" on public.profiles
for select to authenticated using (id = auth.uid() or public.is_admin());
create policy "profiles insert own" on public.profiles
for insert to authenticated with check (id = auth.uid());
create policy "profiles update own" on public.profiles
for update to authenticated using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy "published subjects visible" on public.subjects
for select to anon, authenticated using (is_published or public.is_admin());
create policy "admins manage subjects" on public.subjects
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "published missions visible" on public.missions
for select to anon, authenticated using (
  (status = 'published' and exists (
    select 1 from public.subjects s where s.id = subject_id and s.is_published
  )) or public.is_admin()
);
create policy "admins manage missions" on public.missions
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "published questions visible" on public.questions
for select to anon, authenticated using (
  exists (select 1 from public.missions m where m.id = mission_id and m.status = 'published')
  or public.is_admin()
);
create policy "admins manage questions" on public.questions
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "options visible for published questions" on public.question_options
for select to anon, authenticated using (
  exists (
    select 1 from public.questions q join public.missions m on m.id = q.mission_id
    where q.id = question_id and m.status = 'published'
  ) or public.is_admin()
);
create policy "admins manage options" on public.question_options
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "only admins can view answer keys" on public.question_answer_keys
for select to authenticated using (public.is_admin());
create policy "only admins manage answer keys" on public.question_answer_keys
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "players view own progress" on public.player_progress
for select to authenticated using (user_id = auth.uid() or public.is_admin());
create policy "players insert own progress" on public.player_progress
for insert to authenticated with check (user_id = auth.uid());
create policy "players update own progress" on public.player_progress
for update to authenticated using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

grant select on public.subjects, public.missions, public.questions, public.question_options to anon, authenticated;
grant select, insert, update on public.profiles to authenticated;
grant select, insert, update on public.player_progress to authenticated;
grant select on public.question_answer_keys to authenticated;

insert into public.subjects (title, description, icon_key, sort_order, is_published)
values
 ('Matematik', 'Cabaran nombor, pola dan logik.', 'calculator', 1, true),
 ('Sains', 'Teroka eksperimen dan alam semula jadi.', 'flask-conical', 2, true),
 ('Bahasa', 'Asah kemahiran bahasa dan kefahaman.', 'book-open', 3, true),
 ('Sejarah', 'Jelajah peristiwa dan tamadun.', 'landmark', 4, true)
on conflict do nothing;
