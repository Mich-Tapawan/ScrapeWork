# ScrapeWork

Personal freelance intelligence watchtower + pitch engine.

## Packages

| Path | Role |
|------|------|
| `web/` | Next.js dashboard (+ `app/api` Route Handlers when needed) |
| `scrapers/` | Platform extractors → n8n webhook |
| `supabase/` | Postgres migrations |
| `n8n/` | Exported automation workflows |
| `.cursorrules/` | Product + agent docs |

## Quick start (dashboard)

```bash
cd web
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000). Health check: `/api/health`.

Agent instructions: `.cursorrules/AGENTS.md`.
