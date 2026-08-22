# Data Schema & Contracts

## Postgres (`job_listings`)

| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | `gen_random_uuid()` |
| platform | TEXT | `OnlineJobs.ph` \| `Upwork` \| `Fiverr` |
| external_id | TEXT UNIQUE | Post id or hashed URL |
| title | TEXT | |
| client_name | TEXT | nullable |
| raw_description | TEXT | |
| url | TEXT | |
| employer_email | TEXT | nullable; from scrape when available |
| posted_at | timestamptz | nullable; post time on platform |
| salary_raw | TEXT | nullable; original budget/rate string |
| salary_min | NUMERIC | nullable; parsed when possible |
| salary_max | NUMERIC | nullable |
| currency | TEXT | default `USD` |
| match_score | INT | 0–100 from Stage 1 LLM |
| llm_summary | TEXT | 1–2 sentences (Stage 1) |
| key_skills | TEXT[] | Stage 1 |
| red_flags | TEXT[] | Stage 1 |
| generated_cover_letter | TEXT | **NULL until Stage 2** |
| generated_email | TEXT | **NULL until Stage 2** |
| generated_cold_dm | TEXT | **NULL until Stage 2** |
| created_at | timestamptz | default now() |

## Postgres (`user_assets`)

| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| asset_name | TEXT | e.g. `typing_test`, `speed_test`, `english_proficient` |
| drive_url | TEXT | Drive or Supabase Storage URL |
| updated_at | timestamptz | |

Loaded during Stage 2 for asset link injection into pitches.

## Postgres (`user_profile`)

Single personal profile row (or one row per user later). Source for Stage 1/2 LLM context instead of hardcoding the prompt-only profile.

| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| full_name | TEXT | |
| professional_title | TEXT | |
| bio | TEXT | nullable |
| skills | TEXT[] | |
| github_url | TEXT | |
| linkedin_url | TEXT | |
| portfolio_url | TEXT | |
| resume_drive_url | TEXT | |
| projects_json | JSONB | `[{title, description, stack, link}]` |
| awards_json | JSONB | `[{title, issuer, date}]` |
| updated_at | timestamptz | |

## Scraper → Stage 1 (raw job)

```json
{
  "platform": "Upwork",
  "external_id": "string",
  "title": "string",
  "client_name": "string|null",
  "raw_description": "string",
  "url": "string",
  "employer_email": "string|null",
  "salary_raw": "string|null",
  "salary_min": "number|null",
  "salary_max": "number|null",
  "currency": "string|null",
  "posted_at": "ISO-8601|null"
}
```

## Stage 1 LLM → DB (filter only)

Load `user_profile` for context. Valid JSON: `match_score`, `llm_summary`, `key_skills`, `red_flags`. **No pitch fields.**

## Stage 2 LLM → DB (on "Draft Pitch")

Load `user_profile` + `user_assets`. Valid JSON: `cover_letter`, `short_email`, `cold_dm`. Persist into `generated_*` columns.

## Alert threshold

`match_score >= 75` → Telegram/Discord with score, summary, and job/dashboard link — **not** a pitch preview.
