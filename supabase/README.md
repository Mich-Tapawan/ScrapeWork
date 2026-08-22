# `supabase/`

Postgres schema and migrations for ScrapeWork.

Apply in order in the SQL editor or via CLI:

1. `migrations/001_initial_schema.sql` — `job_listings`, `user_assets`
2. `migrations/002_user_profile_and_job_metadata.sql` — `user_profile` + job salary/email/posted_at columns

Keep `.cursorrules/schema.md` in sync when changing tables. Seed `user_profile` and `user_assets` after migrate (baseline profile + Drive links).
