---
description: Convert a vague idea into a technical specification
---

This workflow turns "I want X" into a rigorous plan.
**Use this BEFORE creating a task.**

---

## 1. Gather Requirements (Invoke Task-Decomposer)

**Load** `.agent/skills/task-decomposer/SKILL.md` and follow its process:
1. Assess complexity (Simple/Medium/Complex)
2. Ask clarifying questions proportional to complexity
3. Resolve all ambiguity before proceeding

> [!NOTE]
> The skill handles adaptive questioning - simple tasks get 1-2 confirms, complex tasks get full elicitation.

---

## 2. Analyze the Codebase & Roadmap
*   Read `package.json`, `index.css`, and relevant components.
*   **Conflict Check (Crucial):**
    *   Read `backlog/tasks/` - Is overlap work already in progress?
    *   Read `backlog/specs/` - Is this feature already defined?
    *   If conflict found → **STOP**. Notify user.
*   Identify existing patterns to reuse.
*   **Search**: Use `backlog search "<concept>"` to check for existing docs or similar tasks.

---

## 2.5 Brainstorming (Optional - Drafts)
*   If the requirements are still fuzzy, use `backlog/drafts/` to brainstorm.
*   Create a file `backlog/drafts/idea-<name>.md` to jot down thoughts before formalizing.
*   Once clear, convert the draft into a spec and tasks.


---

## 3. Draft the Specification
*   Create `backlog/specs/feature-<name>.md`.
*   Include:
    *   **User Stories** (As a user, I want...)
    *   **Acceptance Criteria** (Given/When/Then)
    *   **Technical Implementation** (Approach, file changes)
    *   **Database Changes** (if any)
    *   **Out of Scope** (What we're NOT doing)

---

## 4. Review with User
*   Present the spec for approval.
*   Ask: "Is there anything I missed or got wrong?"
*   If changes needed → Update spec → Re-review

---

## 5. Assign Skills (Skill Orchestrator)
*   Load `.agent/skills/skill-orchestrator/SKILL.md`
*   Analyze the spec for skill keywords
*   Determine skills for resulting tasks

---

## 6. Generate Task Files (REQUIRED)

> [!CAUTION]
> **DO NOT SKIP THIS STEP.** Tasks must be created as actual files in `backlog/tasks/`.

### Task File Requirements

**Filename Convention:** `task-N - Title-With-Dashes.md`
- Example: `task-6 - Create-agent-skills-package-Folder.md`
- Use next available task number (check existing files)

**Required Frontmatter:**
```yaml
---
id: task-N
title: Human Readable Title
status: To Do
assignee: []
created_date: 'YYYY-MM-DD HH:MM'
labels:
  - Feature  # or Infrastructure, Bug, etc.
dependencies: []  # or [task-5] if depends on another
priority: medium  # low, medium, high
effort: M  # XS, S, M, L, XL
skills: [skill-name]
spec: backlog/specs/feature-name.md  # REQUIRED: Link back to parent spec
related_adr: backlog/decisions/adr-name.md  # Optional: If architectural change
branch: feature/spec-name  # REQUIRED if >2 tasks, else 'main'
milestone: "Milestone Name"  # REQUIRED if task belongs to a milestone (must match config.yml)
verification: auto  # REQUIRED: 'auto' or 'manual' (see Verification Mode below)
---
```

**Verification Mode (`verification:` field):**
| Value | When to Use |
|-------|-------------|
| `auto` | Build passes = verified. No human check needed. (e.g., pure logic, refactoring, documentation) |
| `manual` | Requires human verification. (e.g., UI changes, visual design, mobile responsiveness, user-facing flows) |

> [!IMPORTANT]
> **Autonomous Execution (`/execute-spec`) will STOP if it encounters a task with `verification: manual`.**
> Use this field to protect tasks that require visual or subjective review.

**Task Body:**
```markdown
## Description
<!-- SECTION:DESCRIPTION:BEGIN -->
Brief description of the task.

## Context
- **Spec:** [Feature Name](file:///path/to/backlog/specs/feature-name.md)
- **Phase:** [Step # from Implementation Plan] (file:///path/to/backlog/specs/project/IMPLEMENTATION-PLAN.md)
- **ADR:** [Decision Name](file:///path/to/backlog/decisions/adr-name.md) (if applicable)
- **Branch:** `feature/spec-name` (or `main` if ≤2 tasks)

## Detailed Actions (Required)
<!-- Copy checklist from Implementation Plan if applicable -->
- [ ] Action 1
- [ ] Action 2

## Expected Outcome
- [Description of final state]

## Verification Plan
- [ ] Autos-test command / Manual check step

## Subtasks
- [ ] Subtask 1
- [ ] Subtask 2

## Skills Sequence
1. `skill-name` - Why this skill
<!-- SECTION:DESCRIPTION:END -->
```

### Milestone Logic (CRITICAL)

**Determine if a Milestone is needed BEFORE generating tasks:**

| Scenario | Milestone Action |
|----------|------------------|
| **Decomposing a full Phase** from `IMPLEMENTATION-PLAN.md` | **Create Milestone file** + register in config.yml |
| **Large Feature (> 10 tasks)** | **Create Milestone file** to group related tasks |
| **Partial work within an existing Phase** | **Ask user** which milestone to assign tasks to |
| **Small independent feature** (< 10 tasks, not part of a phase) | No milestone needed |

> [!IMPORTANT]
> **Backlog Browser Compatibility:** Tasks MUST be in `backlog/tasks/` to appear in the browser dashboard.
> Use the `milestone:` frontmatter field to group tasks, NOT nested folders.

**Folder Structure:**
```
backlog/
├── tasks/                              # ALL tasks go here
│   ├── task-1 - Create-VM.md           # With milestone: field in frontmatter
│   ├── task-2 - Network.md
│   └── ...
├── milestones/                         # Milestone metadata files
│   └── milestone-1 - Phase-Name.md
└── specs/
```

**Milestone File Format:** `backlog/milestones/milestone-N - Phase-Name.md`
```yaml
---
id: milestone-1
title: "Phase 1: Oracle Cloud Infrastructure"
status: Not Started
created_date: 'YYYY-MM-DD HH:MM'
phase_ref: Phase 1 (from IMPLEMENTATION-PLAN.md)
tasks: [task-1, task-2, task-3, task-4, task-5]
spec: backlog/specs/feature-name.md
branch: feature/phase1-name
---

## Description
Brief description of what this milestone achieves.

## Tasks in this Milestone
- [ ] [Task-1: Title](../tasks/task-1%20-%20Title.md)
- [ ] [Task-2: Title](../tasks/task-2%20-%20Title.md)

## Completion Criteria
- All tasks completed
- Verification plan passed
```

**Also register in `backlog/config.yml`:**
```yaml
milestones: ["Phase 1: Oracle Cloud Infrastructure"]
```

**Clarifying Question (for partial work):**
> "I see you're adding tasks related to [topic]. Should these belong to an existing milestone?
> - **A)** Assign to `Phase 1: Oracle Cloud Infrastructure`
> - **B)** Create new milestone
> - **C)** No milestone (standalone tasks)"

---

### Task Generation Rules
- **ALL tasks** → Create in `backlog/tasks/`
- **Tasks with milestone** → Add `milestone: "Milestone Name"` to frontmatter
- **Implementation Plan Tasks** → You MUST copy the "Detailed Actions" from the plan into a `## Detailed Actions (Required)` section in the task body.
- **ALWAYS create physical files** - Never just document in the spec.
- **Bi-directional Linking**: After creating task files, append a list of them to the Spec file:

```markdown
## Generated Tasks (Auto-Generated)
- [ ] [Task-6: Create Package](file:///path/to/task-6.md)
- [ ] [Task-7: Rewrite Script](file:///path/to/task-7.md)
```

---

## 7. Check ADR Trigger

Ask: "Does this introduce new technology, patterns, or architecture changes?"
- **Yes** → Load `adr-manager` skill, create ADR in `backlog/decisions/`
- **No** → Proceed

---

## 8. Testing Strategy (Invoke Test-Strategist)

**Load** `.agent/skills/test-strategist/SKILL.md` and:
1. Evaluate if tests are needed (impact matrix)
2. Select test type (Unit/Integration/E2E)
3. Document the test plan in the spec using the Output Template
4. Note: Tests are WRITTEN during task execution, VERIFIED during /finish-spec

---

## 9. Create Feature Branch (If >2 Tasks)

**Count the tasks generated in Step 6.**

| Task Count | Action |
|------------|--------|
| ≤2 tasks | No branch needed. Work on current branch. |
| >2 tasks | Create feature branch before starting any tasks. |

**Branch Creation (for >2 tasks):**
```bash
git checkout -b feature/<spec-name>
# Example: git checkout -b feature/skills-migration
```

**Branch Naming Convention:**
- `feature/<kebab-case-spec-name>`
- Derived from the spec filename (e.g., `feature-skills-migration.md` → `feature/skills-migration`)

> [!NOTE]
> Individual tasks do NOT create sub-branches. All task commits go to the feature branch.
> After ALL tasks complete, use `/finish-spec` to quality-check and merge.

---

## 10. Commit Generated Files (REQUIRED)
- **Review:** Use `git status` to check the created files.
- **Stage:** `git add backlog/specs/*.md backlog/tasks/*.md backlog/milestones/*.md`
- **Commit:** `git commit -m "docs: generate spec and tasks for <feature-name>" -m "- Generated spec file: backlog/specs/feature-<name>.md
- Generated task files for implementation
- Initialized feature branch"`

---

## Definition of Done (Spec Complete When)

- [ ] All clarifying questions answered
- [ ] Codebase analyzed for patterns/constraints
- [ ] Spec file created in `backlog/specs/`
- [ ] User has reviewed and approved
- [ ] Skills assigned via skill-orchestrator
- [ ] **Task FILES created in `backlog/tasks/`** (not just documented)
- [ ] Testing strategy documented
- [ ] ADR created (if architectural change)
- [ ] **Generated artifacts committed** (specs, tasks, milestones)
- [ ] **Feature branch created** (if >2 tasks)

---

> [!CAUTION]
> ## WORKFLOW ENDS HERE - DO NOT IMPLEMENT
> 
> After completing this workflow:
> 1. **STOP.** Do not start coding or executing tasks.
> 2. **Notify user** that the spec, tasks, and branch (if any) are ready.
> 3. **Wait for `/start-task`** workflow to be invoked for each task.
> 4. After all tasks: User invokes `/finish-spec` for holistic review.
> 
> The `/start-task` workflow is the ONLY way to begin implementation.


