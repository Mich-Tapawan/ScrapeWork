# Architecture

## Pipeline (source of truth)

```
Cron / schedule
  → platform scrapers (OnlineJobs.ph | Upwork | Fiverr)
  → n8n ingest webhook
  → LLM analysis (score, summary, 3 pitch formats, asset link injection)
  → Supabase save + asset vault lookup
  → high-fit alert (Telegram / Discord) if match_score ≥ 75
  → ScrapeWork dashboard (read from Supabase)
```

## Package boundaries

| Package | Responsibility | Must not |
|---------|----------------|----------|
| `web/` | Watchtower UI + optional Next.js Route Handlers under `app/api/` | Scrape sites or call OpenAI directly for scoring |
| `scrapers/` | Extract raw job payloads; push to n8n webhook | Call LLM or write pitches |
| `n8n/` | Orchestration, LLM nodes, alert routing | Store business UI |
| `supabase/` | Schema, migrations, RLS if any, storage metadata | Application logic |

## Repo layout

```
ScrapeWork/
  .cursorrules/          # Agent + product docs
  .cursor/rules/         # Cursor auto-applied rules
  web/                   # Next.js dashboard (+ app/api Route Handlers)
  scrapers/              # Playwright / requests modules per platform
  supabase/              # migrations + seed
  n8n/                   # exported workflows (JSON)
  README.md
```

## Backend note

No separate Flask service. Prefer Supabase from Server Components / client; use `web/app/api/**/route.ts` only when you need a server endpoint (secrets, webhooks into the dashboard app).

## Contracts

- Scrapers emit a **raw job** payload → n8n.
- LLM returns **enriched job** JSON → Supabase `job_listings`.
- Dashboard reads `job_listings` + `user_assets` only.
- Do not couple scrapers to Next.js UI code.
