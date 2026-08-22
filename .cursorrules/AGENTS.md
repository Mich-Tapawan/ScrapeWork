# ScrapeWork — Agent Instructions

Read this file before writing code. Product requirements live in `MVP.md`.

## What this product is

ScrapeWork is a **personal** freelance intelligence watchtower + pitch engine. It scrapes OnlineJobs.ph, Upwork, and Fiverr, scores fit with an LLM, drafts cover letters / emails / cold DMs, stores verification asset links, and surfaces high-fit jobs in a dashboard with Telegram/Discord alerts.

This is a personal tool, not a multi-tenant SaaS. Prefer simplicity over abstraction.

## Source of truth

| Doc | Use for |
|-----|---------|
| `MVP.md` | Features, schema, LLM prompt, anti-detection ops |
| `architecture.md` | System boundaries, intended folder layout, data flow |
| `stack.md` | Languages, frameworks, conventions per package |
| `scraping.md` | Scraper safety, sessions, polling |
| `ui.md` | Dashboard UX and UI constraints |
| `schema.md` | Postgres tables and JSON contracts |

## Non-negotiables

1. **Do not auto-submit applications.** Generate pitches and links; the human applies.
2. **Never commit secrets** — cookies, API keys, session tokens, `.env`, n8n credentials.
3. **Respect platform ToS and rate limits** — staggered polling + jitter; no aggressive hammering.
4. **LLM output must be valid JSON** matching the pitch/analysis schema; validate before DB write.
5. **Match score ≥ 75** triggers high-priority alerts only.
6. **Asset vault** stores URLs only (Drive/Storage links), not binary files in git.

## How to work

1. Confirm which package you are in (`web`, `scrapers`, `supabase`, `n8n`).
2. Prefer existing patterns in that package; do not invent a parallel stack.
3. Keep changes scoped — one concern per PR/change set.
4. When schema changes, update `schema.md` + Supabase migrations together.
5. When adding a platform scraper, mirror the shared job payload contract (see `schema.md`).
6. Dashboard HTTP endpoints live in `web/app/api/` (Next Route Handlers), not a separate Flask service.

## Out of scope for MVP

- Multi-user auth / teams
- Auto-apply bots
- Payment / billing
- Mobile apps
