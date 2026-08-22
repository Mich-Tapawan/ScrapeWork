-- ScrapeWork initial schema (job listings + asset vault)

CREATE TABLE IF NOT EXISTS job_listings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    platform TEXT NOT NULL,
    external_id TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    client_name TEXT,
    raw_description TEXT NOT NULL,
    url TEXT NOT NULL,
    match_score INT NOT NULL,                 -- Stage 1 LLM (0-100)
    llm_summary TEXT,
    key_skills TEXT[],
    red_flags TEXT[],
    -- NULL until user clicks Draft Pitch (Stage 2)
    generated_cover_letter TEXT,
    generated_email TEXT,
    generated_cold_dm TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_name TEXT NOT NULL,
    drive_url TEXT NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_job_listings_match_score ON job_listings (match_score DESC);
CREATE INDEX IF NOT EXISTS idx_job_listings_created_at ON job_listings (created_at DESC);
