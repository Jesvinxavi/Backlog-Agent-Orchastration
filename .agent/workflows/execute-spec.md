---
description: Autonomously execute a series of tasks for a spec with strict safety checks.
---

# Execute Spec Workflow

**Purpose:** Execute multiple backlog tasks consecutively without human intervention, incorporating the FULL process of `/start-task` and `/commit-task` while adding autonomous safety guardrails.

> [!CAUTION]
> **CORE PRINCIPLE: When in doubt, STOP.**
> This workflow is designed for predictable, low-risk execution. Any ambiguity, confusion, or uncertainty is a valid reason to halt and notify the user.

---

## 1. Setup & Discovery

*   **Load Skill:** `view_file .agent/skills/autonomous-evaluator/SKILL.md`
*   **Identify Tasks:**
    *   Ask the user for the spec if not known/asserted.
    *   List out all the tasks in the spec (check backlog and spec md file)
    *   Filter out tasks that are already "Done".

---

## 2. The Execution Loop (Autonomous)

// turbo-all
**For EACH pending task in the list, perform this loop:**

### Phase A: Pre-Work Safety Check (Autonomous Evaluator)
1.  **Read Task:** Read `backlog/tasks/task-<ID>.md`.
2.  **Check `verification:` Frontmatter (CRITICAL):**
    *   If `verification: manual` is present:
        *   **STOP LOOP.**
        *   Notify User: "Task <ID> requires manual verification. Stopping autonomous run."
3.  **Evaluate Pre-Start Risk:**
    *   Does the task description imply UI work? (e.g. "Button", "Page", "Style").
    *   Does it imply DB work?
    *   **When in doubt about ANY of these, STOP.**
    *   *Action:* If High Risk, **STOP LOOP** and notify user: "Task <ID> requires manual oversight (Reason: UI/DB). Stopping autonomous run."

**Note:** Feature branching happens in `/create-task-spec`. This workflow just loads skills and starts work.

---

### Phase B: Start Task Protocol

*(The following steps are identical to `/start-task`)*

This workflow picks up a task from the backlog and prepares for implementation.
**Note:** Feature branching happens in `/create-task-spec`. This workflow just loads skills and starts work.

---

#### 1. Read the Hive Mind
- Read `docs/KNOWLEDGE.md` to understand past lessons and gotchas.
- Apply any relevant knowledge to the upcoming task.

---

#### 2. Identify the Task
- User provides Task ID (e.g., "6")
- **If no ID provided:**
  - Run `npx backlog.md task list --priority high` to see critical tasks.
  - Pick the top one.
- **Locate Task File (CRITICAL):**
  - **DO NOT** assume the filename.
  - Run: `find backlog/tasks -name "task-<ID>*.md"`
  - **If file NOT found:**
    - **STOP LOOP.**
    - Notify User: "Task file for ID <ID> not found. I will not create a new one autonomously."
  - **If multiple found:**
    - Use the one that matches the naming convention `task-<ID> - <Title>.md` (avoiding duplicates).
- Read the content of the found file.

---

#### 2. Check Dependency Guardrails (CRITICAL)

**Read the `dependencies:` list in the task frontmatter.**
(e.g., `dependencies: [task-6]`)

- **If empty:** Proceed.
- **If populated:** Check the status of each dependent task.
  - If any dependency is NOT `Done`:
    - **STOP LOOP.** Do not start this task.
    - Notify user: "Task <ID> is blocked by <Dep-ID>. Please finish <Dep-ID> first."

---

#### 3. Check Context Links
If stuck or need clarity:
- Read the `spec:` link in frontmatter for full feature context (usually in `backlog/specs/` or `backlog/docs/`)
- Read the `related_adr:` link for architectural decisions

---

#### 4. Check Task-Decomposer Trigger
- If effort is L or XL, or task is vague:
    - **STOP LOOP.** (Autonomous Override: L/XL tasks require human oversight.)
    - Notify User: "Task <ID> is L/XL or too vague for autonomous execution. Stopping for manual decomposition."
- Otherwise, load `.agent/skills/task-decomposer/SKILL.md` if needed and proceed.

---

#### 5. Update Status to "In Progress"
- Use CLI: `npx backlog.md task edit <ID> --status "In Progress"`

---

#### 6. Verify Branch (Do NOT Create)

> [!IMPORTANT]
> Do NOT create a new branch. Feature branches are created in `/create-task-spec`.

**Read the `branch:` field from task frontmatter** to know which branch you should be on.

**Check current branch and switch if needed:**
```bash
git branch --show-current
# If wrong, switch to the branch specified in task frontmatter:
git checkout <branch-from-frontmatter>
```

**Valid scenarios:**
- Task has `branch: main` → You should be on `main`
- Task has `branch: feature/skills-migration` → You should be on `feature/skills-migration`

---

#### 7. Load Relevant Skills
- Check `skills:` field in task frontmatter
- Read each skill's SKILL.md before coding
- Common mappings:
  - UI work → `frontend-mastery`
  - DB work → `supabase-expert`
  - Bugs → `research-deep-dive`

> [!WARNING]
> **Autonomous Override (Skill-Based Risk Re-Evaluation):**
> If `frontend-mastery` or `supabase-expert` is loaded, this indicates HIGH RISK work (UI or DB changes).
> **Re-evaluate with autonomous-evaluator.** Consider issuing a **STOP LOOP** unless you are 100% confident the changes are safe (e.g., purely logic-based work within existing UI).

---

#### 8. Implement the Task
- Follow the subtasks in the task file
- Mark subtasks complete as you go: `- [x]`
  - **CRITICAL:** You MUST physically edit the markdown file to change `[ ]` to `[x]`. Do not just "mentally" mark them.
  - If a step is done, `multi_replace_file_content` the line to `[x]`.
  - If a step is done, `multi_replace_file_content` the line to `[x]`.
  - **VERIFY EDIT:** After running the edit tool, run `view_file` (or `cat`) on the task file.
    - Confirm the `[x]` is actually present.
    - If missing, RETRY the edit.
- **Verification:** Before stopping, scan the file for any remaining `- [ ]`.
  - If found, complete the item OR update the text to explain why it was skipped/changed, then mark `[x]`.
- **STOP** when implementation is complete and ALL items are checked.

---

#### 9. Update Status to "In Review"
- Use CLI: `npx backlog.md task edit <ID> --status "In Review"`

---

#### 10. Notify User
*(Skipped in autonomous loop - proceed to Commit Protocol)*

---

---

> [!CRITICAL]
> **ATOMIC COMMIT ENFORCEMENT:**
> You **MUST** perform the "Commit Task Protocol" (Phase C) **IMMEDIATELY** after completing each task.
> **DO NOT** batch multiple tasks into a single commit.
> **DO NOT** skip the commit step to "save time".
> Each task represents a distinct unit of work and requires its own git history.

---

### Phase C: Commit Task Protocol

*(The following steps are identical to `/commit-task`)*

# Commit Task Workflow

**Use after completing a task, before moving to the next task in a spec.**

This is a lightweight checkpoint - NOT a full quality gate.
Full quality review happens in `/finish-spec`.

---

#### 1. Run Self-Reflection (Deviations & Lessons)
**Load `.agent/skills/self-reflection/SKILL.md`**

1. **Analyze:** Review Plan vs. Reality.
2. **Record Deviations:** Append `## Plan Deviations` to `backlog/tasks/task-<ID>.md`.
3. **Reflect:** Append `## Reflection` to `backlog/tasks/task-<ID>.md`.
   - **CRITICAL:** You MUST do this. Do not skip.
   - **CRITICAL:** You MUST do this. Do not skip.
   - **VERIFY EDIT:** After running the edit tool, run `view_file` on the task file.
     - Confirm the `## Reflection` header is actually present at the bottom.
     - If missing, RETRY the edit.
   - If you skip this, the workflow is invalid.

---

#### 2. Update Changelog
1. **Load `changelog-manager` skill:** (`.agent/skills/changelog-manager/SKILL.md`)
2. **Execute Update:**
   - Add entry for this task.
   - **Format:** `[YYYY-MM-DD] **[Task-<ID>]**: <Summary> (Deviations: ...)`
   - Ensure it is placed under `## [Unreleased]`.
   - **CRITICAL:** You MUST update the Changelog. This is the only source of truth for the user.

---

#### 3. Stage Changes
**Atomic Commit Moment:**
```bash
git add .
```

---

#### 4. Commit with Conventional Format
```bash
git commit -m "<type>(task-<ID>): <description>" -m "- [Bullet point 1 about specific change]
- [Bullet point 2 about specific change]"
```

**Commit Types:**
| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructure |
| `docs` | Documentation only |
| `chore` | Maintenance, deps |

---

#### 5. Quick Build Check
```bash
npm run build
```

| Result | Action |
|--------|--------|
| ✅ Passes | Proceed to next task |
| ❌ Fails | Fix build errors before moving on |

> [!WARNING]
> **Autonomous Override:** If build fails:
> 1. **Attempt ONE fix.**
> 2. **Re-run build.**
> 3. **If it fails again:** **STOP LOOP** and notify user.

---

#### 6. Update Task Status to Done
- Use CLI: `npx backlog.md task edit <ID> --status Done`
- Use CLI for subtasks: `npx backlog.md task edit <ID> --check-ac <index>`

---

#### 7. Notify User
*(Skipped in autonomous loop - proceed to Phase D)*

---

#### What This Does NOT Do
- ❌ Full quality gate (that's `/finish-spec`)
- ❌ KNOWLEDGE.md updates (that's `/finish-spec`)
- ❌ Merge to main (that's `/finish-spec`)

---

### Phase D: Post-Work Safety Check (Autonomous Evaluator)

**Before looping to the next task, perform a final safety check against the rubric.**

1.  **Consult Rubric:** Review changes made against `.agent/skills/autonomous-evaluator/SKILL.md`.
2.  **Explicit Checklist:**
    *   [ ] **Did I touch UI/CSS?** → If yes and changes were not pre-approved, **STOP LOOP**.
    *   [ ] **Did I modify the database schema or RLS?** → If yes, **STOP LOOP**.
    *   [ ] **Did I add new dependencies (`npm install`)?** → If yes, **STOP LOOP**.
    *   [ ] **Do I feel confused or unsure about anything?** → If yes, **STOP LOOP**.
    *   [ ] **Did unit tests or build fail?** → If yes, **STOP LOOP**.
3.  **Decision:**
    *   **PROCEED:** If all checks pass, log: "Task <ID> complete and safe. Starting next task..." and proceed to Phase A for the **Next Task**.
    *   **HALT:** If any check fails, notify user with reason.

---

## 3. Completion

*   **When all tasks are done:**
    *   Notify User: "Autonomous Run Complete. All tasks in spec implemented and verified safe."

---

## Emergency Eject

**AT ANY POINT:**
If you feel "confused", "stuck", or "unsure":
1.  **STOP.**
2.  **Revert:** (Optional, if state is messy) `git restore .`
3.  **Notify User:** "I am pausing the autonomous run at Task <ID>. Reason: <Explanation>."
