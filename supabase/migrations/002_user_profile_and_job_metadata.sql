-- User profile (baseline for Stage 1 filter + Stage 2 pitches)
-- Job listing metadata fields for scrapers / filters

CREATE TABLE IF NOT EXISTS user_profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    professional_title TEXT NOT NULL,
    bio TEXT,
    skills TEXT[],
    github_url TEXT,
    linkedin_url TEXT,
    portfolio_url TEXT,
    resume_drive_url TEXT,
    projects_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    awards_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE job_listings
  ADD COLUMN IF NOT EXISTS employer_email TEXT,
  ADD COLUMN IF NOT EXISTS posted_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS salary_raw TEXT,
  ADD COLUMN IF NOT EXISTS salary_min NUMERIC,
  ADD COLUMN IF NOT EXISTS salary_max NUMERIC,
  ADD COLUMN IF NOT EXISTS currency TEXT DEFAULT 'USD';

CREATE INDEX IF NOT EXISTS idx_job_listings_posted_at ON job_listings (posted_at DESC NULLS LAST);
