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
- Prefer Supabase directly for reads/writes. Use `app/api/**/route.ts` only when a dedicated HTTP endpoint is required.
- Do not embed scrape/LLM scoring logic in the UI.

### `scrapers/` (Python)

- One module per platform under `platforms/` (`onlinejobs.py`, `upwork.py`, `fiverr.py`) + `shared/` types / webhook helper.
- Return normalized raw fields: `platform`, `external_id`, `title`, `client_name`, `raw_description`, `url`, `budget_or_rate`, `posted_at`.
- Cookies and credentials via env or local secret files — never hardcode.

### `n8n/`

- Version-control exported workflow JSON.
- Keep LLM system prompt aligned with `MVP.md` §7; update docs when the prompt changes.

### `supabase/`

- Migrations are the schema source of truth; keep `schema.md` in sync.
