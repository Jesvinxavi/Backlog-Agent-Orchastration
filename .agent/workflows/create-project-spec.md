---
description: Initialize a new project from scratch (Idea -> Architecture -> Codebase)
---

# Create Project Spec Workflow

**Use this ONLY at the very start of a new project.**
It converts a raw idea into a production-ready codebase.

---

## 1. The Deep Interview (Invoke project-decomposer)
**Load** `.agent/skills/project-decomposer/SKILL.md`

> [!IMPORTANT]
> **Adopt the "Proactive Co-Founder" Persona.**
> Do NOT just ask "what do you want?". Instead:
> 1.  **Suggest & Expand**: If user says "chat app", you suggest "End-to-end encryption? Media sharing? Reaction stickers? Offline mode?"
> 2.  **Maximize Utility**: Push for features that make the app "Elite" and highly useful.
> 3.  **Think Ahead**: Ask about scaling, monetization, or virality features early.

1.  **Vision**: Define the core value. *Then suggest 3 "Wow" features to enhance it.*
2.  **Stack Selection**: Recommend the *best* stack, don't just ask. Explain WHY (e.g., "Supabase for Realtime is perfect for this").
3.  **Feature Map**: Define MVP vs V2. *Ensure MVP is not boring "hello world", but a viable product.*
4.  **Constraints**: Auth, Hosting, Budget.

---

## 2. Generate Core Documents
Create these in `docs/`:
- `docs/planning/PRD.md` (Product Requirements)
- `docs/architecture/TECH-SPEC.md` (Stack, Schema, API)
- `docs/architecture/ARCHITECTURE.md` (Diagrams, Data Flow)
- `docs/planning/IMPLEMENTATION-PLAN.md` (Phased execution roadmap)
- `docs/planning/POTENTIAL-FUTURE-FEATURES.md` (Future ideas tracking)

> [!IMPORTANT]
> **IMPLEMENTATION-PLAN.md Requirements:**
> - Must include PRD Traceability Matrix mapping EVERY User Story (US-XX) and Feature (F-XX)
> - Each phase must have detailed numbered sub-steps
> - Each step must include: Purpose, PRD Reference, Detailed Actions, Expected Outcome, Verification
> - Include Verification Plan and Execution Order Summary with time estimates

> [!IMPORTANT]
> **User Review Point**: Pause here. Ask user to review all 4 docs. Do not proceed to code until approved.

---

## 2.5 Customize Task-Decomposer (Project-Specific)

**After docs are approved**, enhance `.agent/skills/task-decomposer/SKILL.md` with project context:

1.  **Add Project-Specific Question Categories:**
    Based on TECH-SPEC.md, add relevant categories. Example:
    - If using Supabase: "RLS Policy Impact?" 
    - If using Stripe: "Payment Edge Cases?"

2.  **Add Project-Specific Anti-Patterns:**
    Based on ARCHITECTURE.md, add things to avoid. Example:
    - "Don't create new tables without updating types"
    - "Don't bypass the feature folder structure"

3.  **Update Effort Guidelines:**
    Based on project complexity, adjust XS-XL definitions if needed.

> [!NOTE]
> This step is optional for simple projects. Apply only if the project has unique patterns worth encoding.

---

## 3. Project Bootstrap (Scaffold)
**Once approved, execute the setup following IMPLEMENTATION-PLAN.md:**

1.  **Initialize Repo**:
    - `npm create vite@latest` (or selected stack)
    - `git init`

2.  **Install Dependencies**:
    - `npm install tailwindcss ...` (based on tech spec)
    - Install Linting/Prettier

3.  **Setup Structure**:
    - Create `src/features`, `src/components`, `src/lib`
    - Create `backlog/` directories (if not present)

4.  **Configuration**:
    - `tsconfig.json`
    - `.eslintrc`
    - `.vscode/extensions.json`

---

## 4. Final Handover
1.  **Commit changes:**
    ```bash
    git commit -m "feat: project initialization" -m "- Initialized repository structure
    - Created backlog and spec directories
    - Installed initial dependencies"
    ```
2.  Notify user: "Project is ready. You can now use `/create-task-spec` for individual features."

---

## Definition of Done (Project Spec Complete When)

- [ ] Vision defined (one-sentence pitch)
- [ ] Stack selected and confirmed by user
- [ ] PRD.md created in `docs/`
- [ ] TECH-SPEC.md created in `docs/`
- [ ] ARCHITECTURE.md created in `docs/`
- [ ] IMPLEMENTATION-PLAN.md created in `docs/` with:
  - [ ] PRD Traceability Matrix (all US-XX and F-XX mapped)
  - [ ] Detailed phased steps with verification
  - [ ] Execution Order Summary with time estimates
- [ ] User has reviewed and approved all 4 docs
- [ ] Repo initialized with correct structure
- [ ] Dependencies installed
- [ ] Initial commit made
