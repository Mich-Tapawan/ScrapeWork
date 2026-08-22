MVP Product Requirements Document
Project Name
ScrapeWork — Personal Freelance Intelligence Watchtower & Pitch Engine
1. Executive Summary
ScrapeWork is a personal automated intelligence platform that continuously monitors freelance job boards (OnlineJobs.ph, Upwork, and Fiverr) for targeted client listings. Beyond scraping and evaluating job fit using an LLM, ScrapeWork acts as a personal pitch engine—automatically drafting tailored cover letters, short emails, and quick cold approach messages based on your specific profile, while storing pre-configured verification assets (typing tests, internet speed tests, and English proficiency certificates) for one-click application submission.
2. Core Vision & Goals
Single Watchtower: Consolidate multiple job boards into one unified dashboard.
Low Latency & Undetectable: Use staggered polling and stealth browser automation to monitor platforms safely.
Smart Filtering: Leverage LLMs to eliminate spam and score fit against your dev profile.
Instant Proposal Generation: Automatically generate platform-appropriate pitches (cover letters, emails, quick DMs) tailored to the exact job post and your past experience.
Asset Vault: Store and automatically link required verification proof (speed tests, typing tests, English proficiency) to eliminate application friction.
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
[ Trigger: Cron / Schedule ]
         │
         ├───> [ OnlineJobs.ph Scraper ] ───┐
         └───> [ Upwork & Fiverr Scraper ] ──┼─> [ n8n Ingest Webhook ]
                                             │
                                             ▼
                                  [ LLM Analysis Node ]
                         (Fit Score, Summary & Draft Pitches)
                                             │
                                             ├────────────────────────┐
                                             ▼                        ▼
                                     [ Database Save ]       [ Pitch Asset Vault ]
                                    (Supabase Postgres)     (Attach Test Drive Links)
                                             │
                                             ▼
                                  [ High-Priority Alert ]
                                 (Telegram + Direct Pitch)
                                             │
                                             ▼
                                  [ ScrapeWork Dashboard ]

5. Core Features & Capabilities
Feature 1: Multi-Platform Scraping Engine
OnlineJobs.ph Module: Lightweight HTTP request parsing targeting keyword search endpoints.
Upwork & Fiverr Modules: Playwright stealth wrapper executing DOM extraction using saved session cookies.
Data Capture: Extracts job title, raw client description, URL, budget/rate, client name (if available), and post timestamp.
Feature 2: LLM Intelligence & Evaluation
Relevance Scoring: Computes a Match Score (0–100%) against your developer profile.
Executive Summary: Generates a 1–2 sentence project overview.
Skill & Red-Flag Extraction: Highlights required tech stack items and flags potential risks (low pay, vague scope).
Feature 3: Automated Multi-Format Pitch Generator
When a job is processed, the LLM ingests your developer profile, past experience, and portfolio data to generate three tailored pitch formats:
Full Cover Letter: A structured proposal for formal platforms (Upwork).
Short Email Pitch: A direct, 3–4 paragraph email pitch with subject line (for direct outreach or OnlineJobs.ph).
Cold Approach DM: A punchy 2–3 sentence message for instant messaging/inbound platforms (Fiverr / direct chat).
Feature 4: Proposal Asset Vault (Verification Proofs)
Stores Google Drive or Supabase Storage URLs for standard freelancer verification documents:
Typing Speed Test screenshot/certificate.
Internet Speed Test (Ookla/Fast) screenshot.
English Proficiency certificate/test results.
Auto-Insertion: Dynamically appends formatted Drive links to generated pitches whenever a client post explicitly requests proof of internet speed or English fluency.
Feature 5: High-Priority Alert & Copy System
Threshold Routing: Triggers instant push notifications (via Telegram or Discord) for high-fit posts ($\ge$ 75% match).
One-Click Action: Notifications contain match score, pitch draft preview, and a direct link to open the dashboard or application URL.
Feature 6: ScrapeWork Watchtower UI
Real-Time Feed: Display jobs sorted by match score or timestamp with badge indicators for platform type.
Pitch Drawer: Click any job card to expand and view the generated Cover Letter, Short Email, or Cold DM with one-click "Copy to Clipboard" buttons.
Asset Manager Tab: UI modal to view or update your stored Google Drive proof links without modifying code.
6. Data Schema (Supabase / Postgres)
SQL
-- Main job listings table
CREATE TABLE job_listings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    platform TEXT NOT NULL,                   -- 'OnlineJobs.ph', 'Upwork', 'Fiverr'
    external_id TEXT UNIQUE NOT NULL,         -- Unique post ID or hashed URL
    title TEXT NOT NULL,
    client_name TEXT,
    raw_description TEXT NOT NULL,
    url TEXT NOT NULL,
    match_score INT NOT NULL,                 -- Computed by LLM (0-100)
    llm_summary TEXT,
    key_skills TEXT[],
    red_flags TEXT[],
    
    -- Generated Pitch Drafts
    generated_cover_letter TEXT,              -- Formal proposal
    generated_email TEXT,                     -- Email subject + body
    generated_cold_dm TEXT,                   -- 2-3 sentence chat message
    
    created_at TIMESTAMP WITH TIMEZONE DEFAULT NOW()
);

-- User Verification Asset Vault
CREATE TABLE user_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_name TEXT NOT NULL,                 -- e.g., 'typing_test', 'speed_test', 'english_proficient'
    drive_url TEXT NOT NULL,                  -- Google Drive or Storage link
    updated_at TIMESTAMP WITH TIMEZONE DEFAULT NOW()
);

7. LLM System Prompt Configuration
Plaintext
You are the proposal engine for ScrapeWork.

DEVELOPER PROFILE:
- Role: Full-Stack Web Developer & Automation Engineer
- Core Tech: Python, React, Tailwind CSS, Next.js, n8n, SQL
- Experience: Web automation, data scraping, full-stack app design, machine learning integrations.

ASSET LINKS:
- Typing Test: {{ $json.assets.typing_test }}
- Speed Test: {{ $json.assets.speed_test }}
- English Test: {{ $json.assets.english_proficient }}

TASK:
Analyze the job title and description below.
1. Assign a match_score (0-100).
2. Generate a 1-sentence summary.
3. Generate three tailored pitches:
   a. "cover_letter": Formal proposal addressing client pain points and highlighting relevant past projects.
   b. "short_email": Email format with a clear subject line.
   c. "cold_dm": Short 2-3 sentence message focusing on immediate value.
4. If the job post asks for speed test, typing test, or English proof, seamlessly include the corresponding asset link in the pitch.

Return valid JSON matching the required schema.

8. Operational Guidelines & Anti-Detection
Polling Interval: Staggered execution every 3 to 5 minutes per platform with random time jitter.
Session Hijacking: Inject authenticated browser cookies into Playwright sessions to bypass login sequences.
Headless Footprint: Use stealth plugins to hide WebDriver indicators and spoof user-agent headers.
