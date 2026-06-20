-- Supabase schema for Khadmat app backend

create table profiles (
  id uuid primary key references auth.users(id),
  full_name text not null,
  phone text not null unique,
  city text not null,
  rank text not null default 'Bronze',
  rating numeric not null default 0,
  is_verified boolean not null default false,
  total_earnings numeric not null default 0,
  jazz_cash_number text,
  created_at timestamp with time zone default now()
);
