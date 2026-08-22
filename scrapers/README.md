# ScrapeWork scrapers

Extract raw job payloads and POST to the n8n ingest webhook. No LLM / pitch logic here.

## Layout

| Module | Platform |
|--------|----------|
| `platforms/onlinejobs.py` | OnlineJobs.ph (HTTP preferred) |
| `platforms/upwork.py` | Upwork (Playwright + stealth) |
| `platforms/fiverr.py` | Fiverr (Playwright + stealth) |
| `shared/` | Payload shape, webhook client, jitter helpers |

## Run (later)

```bash
python -m venv .venv
pip install -r requirements.txt
# set N8N_INGEST_WEBHOOK_URL and session cookies via env — never commit secrets
```

See `.cursorrules/scraping.md` and `.cursorrules/schema.md`.
