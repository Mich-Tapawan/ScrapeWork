# Stack Conventions

## Declared stack (MVP)

| Layer | Tech |
|-------|------|
| Dashboard + optional HTTP API | Next.js (App Router, Route Handlers), React, Tailwind, TypeScript |
| Orchestration | n8n Cloud |
| Scraping | Python Playwright (+ stealth) for JS sites; requests + BeautifulSoup for static |
| AI | OpenAI GPT-4o and/or Anthropic via n8n AI nodes |
| DB / files | Supabase Postgres + object storage / Drive URL metadata |
| Alerts | Telegram Bot API / Discord webhooks |

## Per-package rules

### `web/` (Next.js)

- App Router only. Read `web/AGENTS.md` / local Next docs before using unfamiliar APIs (Next 16 may differ from training data).
- TypeScript strict; no `any` unless justified.
- Tailwind for styling; colocate UI under `components/`, data access under `lib/`.
- Server Components by default; client components only for clipboard, drawers, forms.
- Prefer Supabase directly for reads/writes. Use `app/api/**/route.ts` for Stage 2 "Draft Pitch" triggers or when secrets must stay server-side.
- Do not embed scrape or Stage 1 scoring logic in the UI. Do not generate pitch text in the browser.

### `scrapers/` (Python)

- One module per platform under `platforms/` (`onlinejobs.py`, `upwork.py`, `fiverr.py`) + `shared/` types / webhook helper.
- Return normalized raw fields: `platform`, `external_id`, `title`, `client_name`, `raw_description`, `url`, `employer_email`, `salary_raw`, `salary_min`, `salary_max`, `currency`, `posted_at`.
- Cookies and credentials via env or local secret files — never hardcode.

### `n8n/`

- Version-control exported workflow JSON.
- Stage 1 workflow: ingest → cheap filter LLM → Supabase (pitches NULL) → optional alert.
- Stage 2 workflow (or web-triggered): pitch LLM → update `generated_*`. Align prompts with `MVP.md` §7a/§7b.

### `supabase/`

- Migrations are the schema source of truth; keep `schema.md` in sync.
