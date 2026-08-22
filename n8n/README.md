# `n8n/`

Export n8n Cloud workflows here as JSON so orchestration stays versioned.

Expected pipeline nodes (see `.cursorrules/architecture.md`):

1. Webhook ingest (from scrapers)
2. Load `user_assets` from Supabase
3. LLM analysis + pitch generation (`MVP.md` §7)
4. Upsert `job_listings`
5. Branch: if `match_score >= 75` → Telegram / Discord alert

Do not commit API keys or credential exports with secrets.
