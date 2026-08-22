MVP Product Requirements Document
Project Name
ScrapeWork — Personal Freelance Intelligence Watchtower & Pitch Engine
1. Executive Summary
ScrapeWork is a personal automated intelligence platform that continuously monitors freelance job boards (OnlineJobs.ph, Upwork, and Fiverr) for targeted client listings. It scrapes and evaluates job fit using a cheap LLM filter, then acts as an on-demand pitch engine—drafting tailored cover letters, short emails, and cold approach messages only when you click "Draft Pitch" on a job you intend to apply for—while storing verification asset links (typing tests, internet speed tests, English proficiency) for inclusion in those drafts.
2. Core Vision & Goals
Single Watchtower: Consolidate multiple job boards into one unified dashboard.
Low Latency & Undetectable: Use staggered polling and stealth browser automation to monitor platforms safely.
Smart Filtering: Leverage LLMs to eliminate spam and score fit against your dev profile (without generating full pitches upfront).
On-Demand Proposal Generation: Generate platform-appropriate pitches only when the user requests them for a specific job.
Asset Vault: Store and automatically link required verification proof (speed tests, typing tests, English proficiency) when a pitch is drafted.
3. Technology Stack
Frontend Dashboard: HTML5, Tailwind CSS, Next.js (App Router; optional Route Handlers under `web/app/api/`)
API Backend: None separate for MVP — Supabase + Next.js Route Handlers as needed (no Flask)
Workflow & Automation Engine: n8n (Cloud)
Scraping Engine: Python (Playwright / puppeteer-extra-plugin-stealth for JS-heavy targets; BeautifulSoup / requests for static sites)
AI / Intelligence Layer: OpenAI API (GPT-4o) / Anthropic API via n8n AI Nodes
Database & Storage: Supabase (PostgreSQL + Object Storage / Drive URL metadata)
Notifications: Telegram Bot API / Discord Webhooks
4. System Architecture
Plaintext
[ Cron / Schedule Trigger ]
              │
   [ Multi-Platform Scrapers ]
              │
              ▼
   [ Stage 1: Ingestion Pipeline ]
 (Title, Raw Description, Client, URL)
              │
              ▼
   [ LLM Filter (Cheap Prompt) ]
 (Match Score, Summary, Skills, Red Flags)
              │
              ▼
   [ Save to Supabase ]
 (Pitch columns left NULL)
              │
     ┌────────┴────────┐
     │ score < 75      │ score >= 75
     ▼                 ▼
[ DB only ]    [ High-Priority Alert ]
               (Telegram + dashboard link)
                       │
                       ▼
            [ Next.js Watchtower UI ]
                       │
          (User clicks "Draft Pitch")
                       │
                       ▼
         [ Stage 2: Pitch Generator ]
    (Cover letter, email, cold DM → save)

5. Core Features & Capabilities
Feature 1: Multi-Platform Scraping Engine
OnlineJobs.ph Module: Lightweight HTTP request parsing targeting keyword search endpoints.
Upwork & Fiverr Modules: Playwright stealth wrapper executing DOM extraction using saved session cookies.
Data Capture: Extracts job title, raw client description, URL, budget/rate, client name (if available), and post timestamp.
Feature 2: LLM Intelligence & Evaluation (Stage 1 — every ingested job)
Relevance Scoring: Computes a Match Score (0–100%) against your developer profile.
Executive Summary: Generates a 1–2 sentence project overview.
Skill & Red-Flag Extraction: Highlights required tech stack items and flags potential risks (low pay, vague scope).
Does not generate pitches at this stage.
Feature 3: On-Demand Multi-Format Pitch Generator (Stage 2 — user-triggered)
When the user clicks "Draft Pitch" on a job (typically when preparing to apply), the LLM ingests your developer profile, past experience, portfolio data, and that job's description to generate three tailored pitch formats:
Full Cover Letter: A structured proposal for formal platforms (Upwork).
Short Email Pitch: A direct, 3–4 paragraph email pitch with subject line (for direct outreach or OnlineJobs.ph).
Cold Approach DM: A punchy 2–3 sentence message for instant messaging/inbound platforms (Fiverr / direct chat).
Results are saved to the job's `generated_*` columns (replacing NULLs). Re-draft may overwrite previous drafts.
Feature 4: Proposal Asset Vault (Verification Proofs)
Stores Google Drive or Supabase Storage URLs for standard freelancer verification documents:
Typing Speed Test screenshot/certificate.
Internet Speed Test (Ookla/Fast) screenshot.
English Proficiency certificate/test results.
Auto-Insertion: Dynamically appends formatted Drive links to generated pitches (Stage 2 only) whenever a client post explicitly requests proof of internet speed or English fluency.
Feature 5: High-Priority Alert & Copy System
Threshold Routing: Triggers instant push notifications (via Telegram or Discord) for high-fit posts (≥ 75% match).
One-Click Action: Notifications contain match score, short summary, and a direct link to open the dashboard or application URL — not a full pitch preview (pitches do not exist until Draft Pitch).
Feature 6: ScrapeWork Watchtower UI
Real-Time Feed: Display jobs sorted by match score or timestamp with badge indicators for platform type.
Job detail / drawer: Show score, summary, skills, red flags. Primary CTA: "Draft Pitch" when pitches are NULL; after generation, show Cover Letter / Short Email / Cold DM with one-click Copy.
Asset Manager Tab: UI modal to view or update your stored Google Drive proof links without modifying code.
6. Data Schema (Supabase / Postgres)
SQL
-- See supabase/migrations/001_initial_schema.sql and 002_user_profile_and_job_metadata.sql

-- job_listings: platform fields + Stage 1 scores + nullable Stage 2 pitches
--   also: employer_email, posted_at, salary_raw, salary_min, salary_max, currency
-- user_assets: verification Drive/Storage URLs
-- user_profile: full_name, title, bio, skills, links, projects_json, awards_json
--   (loaded into Stage 1 filter + Stage 2 pitch prompts)

7. LLM System Prompt Configuration

7a. Stage 1 — Filter (cheap prompt, every job)
Plaintext
You are the intake filter for ScrapeWork.

DEVELOPER PROFILE: (load from user_profile row)
- Name / title / bio / skills / projects as provided in context JSON.

TASK:
Analyze the job title and description below.
1. Assign a match_score (0-100).
2. Generate a 1-2 sentence summary.
3. Extract key_skills (array) and red_flags (array).
Do NOT generate cover letters, emails, or DMs.

Return valid JSON: match_score, llm_summary, key_skills, red_flags.

7b. Stage 2 — Pitch generator (only on "Draft Pitch")
Plaintext
You are the proposal engine for ScrapeWork.

DEVELOPER PROFILE: (load from user_profile — name, title, bio, skills, projects_json, awards_json, portfolio/github/linkedin/resume links)

ASSET LINKS: (load from user_assets)
- Typing Test: {{ $json.assets.typing_test }}
- Speed Test: {{ $json.assets.speed_test }}
- English Test: {{ $json.assets.english_proficient }}

TASK:
Given this job (already scored), generate three tailored pitches:
a. "cover_letter": Formal proposal addressing client pain points and highlighting relevant past projects.
b. "short_email": Email format with a clear subject line.
c. "cold_dm": Short 2-3 sentence message focusing on immediate value.
If the job post asks for speed test, typing test, or English proof, seamlessly include the corresponding asset link.

Return valid JSON: cover_letter, short_email, cold_dm.

8. Operational Guidelines & Anti-Detection
Polling Interval: Staggered execution every 3 to 5 minutes per platform with random time jitter.
Session Hijacking: Inject authenticated browser cookies into Playwright sessions to bypass login sequences.
Headless Footprint: Use stealth plugins to hide WebDriver indicators and spoof user-agent headers.
