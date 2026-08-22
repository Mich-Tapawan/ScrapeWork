# Scraping & Ops Safety

Personal monitoring tool. Agents must optimize for **stealth and longevity**, not throughput.

## Required behaviors

- **Polling**: stagger every 3–5 minutes per platform with random jitter. Never tight loops.
- **Sessions**: inject saved authenticated cookies into Playwright; do not automate full login flows in code unless explicitly requested.
- **Stealth**: use stealth plugins / spoofed UA; avoid obvious WebDriver fingerprints.
- **Static vs JS**: OnlineJobs.ph → lightweight HTTP parsing when possible; Upwork/Fiverr → Playwright stealth.
- **Idempotency**: `external_id` (post id or hashed URL) must be unique before insert — skip duplicates silently.
- **Failures**: retry with backoff; alert on repeated auth/session death, do not thrash.

## Forbidden

- Parallel blast requests against the same platform.
- Committing cookie jars, storage state JSON with secrets, or `.env`.
- Auto-clicking Apply / sending messages to clients.
- Building CAPTCHA-solving or credential-stuffing helpers.

## Payload handoff

Scrapers only extract and POST to the n8n ingest webhook. Scoring and pitches happen downstream.
