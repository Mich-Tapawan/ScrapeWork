# Dashboard UI (`web/`)

## Screens (MVP)

1. **Watchtower feed** — jobs sorted by match score or timestamp; platform badges.
2. **Job drawer** — score, summary, skills, red flags; **"Draft Pitch"** CTA when `generated_*` are NULL; after Stage 2, show cover / email / DM with Copy.
3. **Asset manager / profile** — update Drive proof URLs (`user_assets`) and baseline `user_profile` without modifying code.

## UX rules

- One primary job per interaction: scan feed → open drawer → Draft Pitch (if needed) → copy.
- Show match score prominently; badge high-fit (≥ 75) clearly.
- Do not imply pitches exist before Draft Pitch — empty/NULL state is normal.
- Copy-to-clipboard must work without leaving the page.
- Asset manager is a simple form/modal — no card-heavy marketing layout.
- Personal tool aesthetic: dense, readable, fast — not a landing page.

## Design constraints for agents

Follow the project frontend design rules when building marketing surfaces; the **dashboard is a utility UI** (feed + drawer), so prioritize clarity and speed over hero branding.

## Data display

- Render Stage 1 fields from DB always.
- Render `generated_*` only when present; otherwise show Draft Pitch (trigger Stage 2 — never invent pitch text client-side).
- Empty feed: explain that scrapers/n8n have not produced jobs yet.
