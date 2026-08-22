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
| match_score | INT | 0–100 from LLM |
| llm_summary | TEXT | 1–2 sentences |
| key_skills | TEXT[] | |
| red_flags | TEXT[] | |
| generated_cover_letter | TEXT | |
| generated_email | TEXT | subject + body |
| generated_cold_dm | TEXT | 2–3 sentences |
| created_at | timestamptz | default now() |

## Postgres (`user_assets`)

| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| asset_name | TEXT | e.g. `typing_test`, `speed_test`, `english_proficient` |
| drive_url | TEXT | Drive or Supabase Storage URL |
| updated_at | timestamptz | |

## Scraper → n8n (raw job)

```json
{
  "platform": "Upwork",
  "external_id": "string",
  "title": "string",
  "client_name": "string|null",
  "raw_description": "string",
  "url": "string",
  "budget_or_rate": "string|null",
  "posted_at": "ISO-8601|null"
}
```

## LLM → DB (enriched)

Must return valid JSON including: `match_score`, summary, `key_skills`, `red_flags`, `cover_letter`, `short_email`, `cold_dm`. If the post requests proofs, embed the matching asset URLs from `user_assets`.

## Alert threshold

`match_score >= 75` → Telegram/Discord high-priority notification with score, pitch preview, and job/dashboard link.
