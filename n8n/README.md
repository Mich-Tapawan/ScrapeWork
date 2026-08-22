# `n8n/`

Export n8n Cloud workflows here as JSON so orchestration stays versioned.

## Stage 1 — ingest (every job)

1. Webhook ingest (from scrapers)
2. Load `user_profile` for filter context
3. Cheap filter LLM (`MVP.md` §7a) — score, summary, skills, red flags only
4. Upsert `job_listings` with `generated_*` left NULL (map `salary_raw`, `employer_email`, `posted_at`, etc.)
5. Branch: if `match_score >= 75` → Telegram / Discord (score + summary + dashboard link; no pitch)

## Stage 2 — pitch (on "Draft Pitch" only)

1. Trigger from dashboard (webhook or shared workflow)
2. Load job + `user_profile` + `user_assets`
3. Pitch LLM (`MVP.md` §7b)
4. Update that row’s `generated_cover_letter`, `generated_email`, `generated_cold_dm`

Do not commit API keys or credential exports with secrets.
