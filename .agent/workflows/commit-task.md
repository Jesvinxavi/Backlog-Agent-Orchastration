---
description: Commit task changes with a quick build check
---

# Commit Task Workflow

**Use after completing a task, before moving to the next task in a spec.**

This is a lightweight checkpoint - NOT a full quality gate.
Full quality review happens in `/finish-spec`.

---


## 1. Run Self-Reflection (Deviations & Lessons)
**Load `.agent/skills/self-reflection/SKILL.md`**

1. **Analyze:** Review Plan vs. Reality.
2. **Record Deviations:** Append `## Plan Deviations` to `backlog/tasks/task-<ID>.md`.
   - *Example:* "CHANGED: Used library X instead of Y."
3. **Reflect:** Append `## Reflection` to `backlog/tasks/task-<ID>.md`.
   - *Example:* "Lesson: Always check types before migration."

---

## 2. Update Changelog
1. **Load `changelog-manager` skill:** (`.agent/skills/changelog-manager/SKILL.md`)
2. **Execute Update:**
   - Add entry for this task.
   - **Format:** `[YYYY-MM-DD] **[Task-<ID>]**: <Summary> (Deviations: ...)`
   - Ensure it is placed under `## [Unreleased]`.

---

## 3. Verify Task Checklist (CRITICAL)
1. **Read `backlog/tasks/task-<ID>.md`**.
2. **Scan "Detailed Actions"**:
   - Ensure EVERY checklist item (`- [ ]`) is marked as done (`- [x]`).
   - **If an item is NOT done:**
     - **Verify:** Did you actually do it?
     - **If YES:** Mark it `[x]`.
     - **If NO (Skipped/Changed):** Update the text to reflect the actual implementation (e.g. "Skipped because...") and mark it `[x]`.
   - **CRITICAL:** Do NOT proceed to Stage Changes until all items are marked `[x]`.

---

## 4. Stage Changes
**This is the Atomic Moment.** We stage Code + Documentation + Changelog + Task Status together.

```bash
git add .
```

---

## 5. Commit with Conventional Format
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

## 6. Quick Build Check
```bash
npm run build
```

| Result | Action |
|--------|--------|
| ✅ Passes | Proceed to next task |
| ❌ Fails | Fix build errors before moving on |

> [!WARNING]
> Do NOT proceed to the next task if the build fails.
> Fix the issue and re-commit (amend if trivial, new commit if substantial).

---

## 7. Update Task Status to Done
- **Verify status is `In Review`** (it should be, from start-task).
- Use CLI: `npx backlog.md task edit <ID> --status Done`
- Use CLI for subtasks: `npx backlog.md task edit <ID> --check-ac 1 --check-ac 2 ...` (or verify manually)

---

## 8. Notify User
"Task <ID> committed. Build passes. Ready for next task or `/finish-spec`."

---

## What This Does NOT Do
- ❌ Full quality gate (that's `/finish-spec`)
- ❌ KNOWLEDGE.md updates (that's `/finish-spec`)
- ❌ Merge to main (that's `/finish-spec`)
