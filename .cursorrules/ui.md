# Dashboard UI (`web/`)

## Screens (MVP)

1. **Watchtower feed** — jobs sorted by match score or timestamp; platform badges.
2. **Pitch drawer** — cover letter, short email, cold DM; one-click copy each.
3. **Asset manager** — view/update Drive (or storage) URLs for typing / speed / English proofs.

## UX rules

- One primary job per interaction: scan feed → open drawer → copy pitch.
- Show match score prominently; badge high-fit (≥ 75) clearly.
- Copy-to-clipboard must work without leaving the page.
- Asset manager is a simple form/modal — no card-heavy marketing layout.
- Personal tool aesthetic: dense, readable, fast — not a landing page.

## Design constraints for agents

Follow the project frontend design rules when building marketing surfaces; the **dashboard is a utility UI** (feed + drawer), so prioritize clarity and speed over hero branding.

## Data display

- Never invent pitch text client-side if DB fields exist — render `generated_*` columns.
- Empty states: explain that scrapers/n8n have not produced jobs yet.
