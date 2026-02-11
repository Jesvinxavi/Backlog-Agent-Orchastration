---
name: project-decomposer
description: Triggers at project start. Deeply interviews user to generate PRD, Tech Spec, Architecture Design, and Implementation Plan. Scaffolds entire project structure.
---

# Project Decomposer Skill

**The "Principal Architect" in a box.**
Use this skill to convert a raw idea into a fully scaffolded, production-ready repository.

---

## Trigger
- `/create-project-spec` workflow (Step 1)
- New repository initialization

---

## Phase 1: The Deep Interview (Project Scale)
**Goal:** Extract the "Soul" of the project.
*Don't just ask "what features?". Ask "what success looks like?".*

### Guiding Principle: The Opinionated Partner
**Never ask an open-ended question without providing a path forward.**
- **❌ Bad:** "What database do you want?"
- **✅ Good:** "For this, I recommend **PostgreSQL (Supabase)** because of its relational integrity. Alternatively, we could use Firebase if realtime is the priority. I suggest Supabase to keep options open. Thoughts?"

### 1. The Vision
- "In one sentence, what is this? (e.g., 'Uber for Dog Walkers')"
- "Who is the user? (e.g., 'Busy professionals', 'Teenagers')"
- "What is the 'Magic Moment'? (e.g., 'When the dog is matched')"

### 2. The Stack Selection (Auto-Recommend)
Based on requirements, recommend the stack:
- **Web App**: React, Vite, Tailwind, Supabase
- **Mobile**: React Native / Expo
- **Backend-Heavy**: NestJS / Node
*Ask user to confirm or override.*

### 3. The Feature Map (The "Production-Aware MVP")
**Strategy**: "Build for Speed, Architect for Scale."
- **MVP (P0)**: "What is the absolute minimum to solve the user's problem? (e.g., Simple Chat)" -> *Build this First.*
- **Roadmap (V2)**: "What makes it a billion-dollar app? (e.g., E2E Encryption, AI summarization)" -> *Architect for this (DB schema supports it), but don't build UI yet.*
*Ensure the DB Schema in TECH-SPEC supports V2, but the Codebase only implements MVP.*

### 3.5 The Future Vision (Capture Ideas)
- Ask: "Are there any 'nice-to-have' features or crazy ideas you love but shouldn't be in V1?"
- *Goal*: Capture these in `POTENTIAL-FUTURE-FEATURES.md` so they aren't lost, keeping the MVP focused.

### 4. Technical Constraints
- "Auth provider?" (Supabase, Clerk, Firebase)
- "Database type?" (SQL, NoSQL)
- "Hosting target?" (Vercel, Netlify, AWS)

### 5. The Production Readiness Check (CRITICAL)
**Before finalizing the plan, you MUST "Stress Test" the idea:**
- **Scaling**: "Will this architecture assume 10k users or 1M? If 1M, how do we handle DB load? (Read replicas? Redis?)"
- **Security**: "How do we secure user data? (RLS Policies is NOT optional). How do we handle PII?"
- **Auth**: "What about session expiry? Refresh tokens? Social login edge cases?"
- **Database**: "Are we using proper Foreign Keys? Indexes on query paths? Constraints?"
*Explicitly discuss these with the user to show you are thinking like a CTO.*

---

## Phase 2: Document Generation (The "Ambiguity Killer")

**Rule:** Every document must be detailed enough for a stranger to build the app without asking questions.

Create all 4 documents in `docs/`:

### 1. `docs/planning/PRD.md` (Product Requirements Document)
**Goal:** Zero ambiguity on behaviour.
- **Executive Summary:** The "Elevator Pitch".
- **User Personas:** Detailed (Name, Age, Goal, Frustration).
- **User Stories:** `As a [Persona], I want [Action], So that [Benefit]`.
- **Requirements Table:**
  | ID | Feature | Description | Priority |
  |----|---------|-------------|----------|
  | F-01 | Sign Up | Email/Password + Google Auth | P0 |
- **Non-Functional Requirements:** Performance (<1s load), Scale (10k users), Accessibility.
- **Success Metrics:** "100 Daily Active Users", "Retention > 20%".

### 2. `docs/architecture/TECH-SPEC.md` (Technical Specification)
**Goal:** Zero ambiguity on code structure.
- **Stack Decision:** Frameworks, Libraries with rationale.
- **Data Schema:** 
  - Table definitions (Name, Columns, Types, Relationships).
  - *Example:* `users (id: uuid, email: text, created_at: timestamptz)`
- **API Surface:**
  - `POST /api/auth/login` - Body: {email, password}
  - `GET /api/dashboard` - RLS Protected
- **Project Structure:** File tree diagram.

### 3. `docs/architecture/ARCHITECTURE.md`
**Goal:** Zero ambiguity on data flow.
- **System Diagram:** Mermaid chart showing Frontend -> API -> DB -> External Services.
- **Data Flow:** How data moves for key actions (e.g. Checkout).
- **Security Strategy:** RLS Policies, Auth flow, API Gateways.
- **Third-Party Integrations:** Stripe, SendGrid, AI Models (with fallback strategies).

### 4. `docs/planning/IMPLEMENTATION-PLAN.md` (The Execution Roadmap)
**Goal:** A step-by-step guide that fully implements every user story and feature from the PRD.

### 5. `docs/planning/POTENTIAL-FUTURE-FEATURES.md`
**Goal:** A holding area for ideas that are out of scope for MVP but valuable for the future.
- **Use this template:**
  ```markdown
  # Potential Future Features

  This document tracks potential features or additions that may be useful for the project in the future.
  Entries should include the feature description, why it would be useful, and specific use cases.

  ## Feature Candidates

  <!--
  ### [Feature Name]
  **Description:** ...
  **Why Useful:** ...
  **Use Cases:**
  1. ...
  -->
  ```
- Populate with any ideas captured during the "Future Vision" interview step.

#### Required Sections:

##### A. Goal
A brief description of what this implementation achieves.

##### B. User Review Required
Document anything requiring user decisions before execution:
- Use GitHub alerts (`> [!IMPORTANT]`, `> [!WARNING]`, `> [!CAUTION]`)
- Include breaking changes, significant trade-offs, or ambiguous requirements

##### C. PRD Traceability Matrix
A table mapping every User Story and Feature Requirement to the phase that implements it:

| PRD Reference | Description | Implementation Phase |
|---------------|-------------|---------------------|
| US-01 | User login | Phase 2, Step 3 |
| F-01 | Sign Up feature | Phase 2, Steps 2-4 |
| F-02 | Dashboard | Phase 3, Steps 1-2 |

**CRITICAL: Every single User Story (US-XX) and Feature (F-XX) from PRD.md MUST appear in this table. No exceptions.**

##### D. Phased Implementation Plan
Structure each phase with detailed numbered sub-steps:

```markdown
## Phase N: [Phase Name]
**Goal:** [What this phase accomplishes]
**PRD Coverage:** US-01, US-02, F-01, F-03 (list all addressed in this phase)
**Estimated Duration:** [X hours/days]

### Step N.1: [Step Title]
**Purpose:** [Why this step is needed]
**PRD Reference:** US-01, F-01

**Detailed Actions:**
1. [Specific action with exact command/code/location]
2. [Next specific action]
3. [Continue until step is complete]

**Expected Outcome:** [What success looks like after this step]

**Verification:** [How to confirm this step is complete]

---

### Step N.2: [Next Step Title]
...
```

**Phase Requirements:**
- Each phase must clearly state which User Stories (US-XX) and Features (F-XX) it addresses
- Every numbered step must include:
  - **Purpose**: Why this step exists
  - **PRD Reference**: Which user stories/features this step implements (if applicable)
  - **Detailed Actions**: Exhaustive list of actions with exact commands, file paths, or code snippets
  - **Expected Outcome**: What the system should look like after completion
  - **Verification**: How to confirm the step succeeded
- Steps should be granular enough that no step takes more than 30 minutes
- If a step involves creating a file, show the file path and key contents

##### E. Verification Plan
**Automated Tests:**
- List exact test commands to run
- Include expected pass criteria

**Manual Verification:**
- Step-by-step verification checklist
- Include browser-based tests if applicable

##### F. Execution Order Summary
A summary table showing all phases:

| Step | Phase | Key Tasks | Duration | PRD Coverage |
|------|-------|-----------|----------|--------------|
| 1 | Foundation | Install deps, create structure | 30 min | F-01 |
| 2 | Auth | Login, signup flows | 2 hrs | US-01, US-02, F-02 |
| ... | ... | ... | ... | ... |

**Estimated Total Time:** [Sum of all phases]

##### G. Dependencies & Blockers
- List any external dependencies (API keys, services, hardware)
- Note any potential blockers and mitigation strategies

---

## Phase 3: Project Bootstrap (Scaffold)
**Action:** Execute shell commands to set up the repo.

### 1. Install & Configure
- `npm create vite@latest . -- --template react-ts`
- `npm install tailwindcss postcss autoprefixer ...`
- `npx tailwindcss init -p`

### 2. Setup Directory Structure
- `src/components/ui` (Design System)
- `src/features` (Domain Modules)
- `src/lib` (Utilities, API clients)
- `src/hooks` (Custom hooks)

### 3. Setup Tooling
- ESLint / Prettier config
- VS Code extensions (`.vscode/extensions.json`)
- API Clients (Supabase client)

### 4. Create Core Files
- `CHANGELOG.md`: Start with `## [Unreleased]` section.

---

## Anti-Patterns
- Skipping the "Vision" step (builds the wrong thing)
- Assessing tech stack without knowing requirements
- Creating a monolith implementation plan (break it down!)
- Ignoring "V2" features (leads to dead-end architecture)
- **Creating an Implementation Plan that doesn't cover all PRD items**
- **Vague steps like "set up the backend" without specific actions**
- **Missing verification steps** (how do you know it works?)

---

## Verification Checklist
- [ ] Vision clearly articulated (one-sentence pitch)
- [ ] Stack confirmed by user
- [ ] PRD.md created with all required sections
- [ ] TECH-SPEC.md created with schema and API surface
- [ ] ARCHITECTURE.md created with Mermaid diagram
- [ ] IMPLEMENTATION-PLAN.md created with:
  - [ ] Goal section
  - [ ] User Review Required section (if applicable)
  - [ ] PRD Traceability Matrix (every US-XX and F-XX mapped)
  - [ ] All phases with detailed numbered steps
  - [ ] Each step has Purpose, Detailed Actions, Expected Outcome, Verification
  - [ ] Verification Plan (automated + manual)
  - [ ] Execution Order Summary with time estimates
- [ ] POTENTIAL-FUTURE-FEATURES.md created and populated from Future Vision step
- [ ] All four docs reviewed and approved by user
- [ ] Project bootstrapped with correct folder structure
- [ ] CHANGELOG.md created with initial structure
