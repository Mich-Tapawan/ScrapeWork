# Architecture

## Pipeline (source of truth)

```
Cron / schedule
  → platform scrapers (OnlineJobs.ph | Upwork | Fiverr)
  → n8n Stage 1 ingest
  → cheap LLM filter (match_score, summary, skills, red_flags)
  → Supabase save (generated_* left NULL)
  → if match_score ≥ 75 → Telegram/Discord alert (score + link, no pitch)
  → Watchtower UI
  → user clicks "Draft Pitch"
  → Stage 2 pitch generator (n8n or web Route Handler → LLM)
  → save cover_letter / email / cold_dm on that job row
```

## Two LLM stages

| Stage | When | Output | Must not |
|-------|------|--------|----------|
| 1 — Filter | Every ingested job | score, summary, skills, red_flags | Generate pitches |
| 2 — Pitch | User clicks "Draft Pitch" | cover letter, email, cold DM (+ asset links if needed) | Run for every scrape |

## Package boundaries

| Package | Responsibility | Must not |
|---------|----------------|----------|
| `web/` | Watchtower UI; trigger Stage 2 via Route Handler or n8n webhook | Scrape sites; run Stage 1 scoring in the browser |
| `scrapers/` | Extract raw job payloads; push to n8n Stage 1 webhook | Call LLM or write pitches |
| `n8n/` | Stage 1 ingest + alerts; optional Stage 2 workflow | Store business UI |
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

No separate Flask service. Prefer Supabase from Server Components / client; use `web/app/api/**/route.ts` when triggering Stage 2 or hiding secrets.

## Contracts

- Scrapers emit a **raw job** payload → Stage 1 n8n.
- Stage 1 loads `user_profile`, returns filter JSON only → Supabase (`generated_*` stay NULL).
- Stage 2 loads `user_profile` + `user_assets`, returns pitch JSON → update that job’s `generated_*` columns.
- Dashboard reads `job_listings` + `user_assets` + `user_profile`; Draft Pitch is the only pitch trigger.
- Do not couple scrapers to Next.js UI code.
