---
name: self-reflection
description: Use at the end of every completed task to analyze what went well, what could improve, and capture lessons for KNOWLEDGE.md. Triggers automatically after /finish-task workflow.
---

# Self-Reflection Skill

Analyze completed work to improve future performance.

---

## When to Trigger

- After completing any task (automatically via /finish-task)
- After encountering unexpected difficulties
- After making mistakes that required backtracking
- When discovering patterns worth documenting

---

## Reflection Process

### 1. Task Analysis
Ask yourself:
- **Plan vs Reality:** Did I follow the implementation plan exactly?
- **Checklist Integrity:** Did I mark every `- [ ]` item as done? If I skipped one, did I update the text to explain why?
- **Deviations:** If I changed the approach, added extra steps, or skipped steps, I **MUST** record these clearly.
- Did I achieve the goal completely?
- What unexpected challenges arose?

### 2. Quality Assessment
| Dimension | Question |
|-----------|----------|
| Accuracy | Did my solution work correctly first try? |
| Efficiency | Did I take the most direct path? |
| Completeness | Did I handle edge cases? |
| Communication | Did I explain changes clearly? |

### 3. Pattern Recognition
Identify:
- Repeated mistakes (candidate for skill improvement)
- Successful patterns (candidate for skill creation)
- Knowledge gaps (candidate for KNOWLEDGE.md)
- Process friction (candidate for workflow creation)
- **Future Feature Ideas** (candidate for `POTENTIAL-FUTURE-FEATURES.md`)

### 4. Knowledge Capture
If lesson is valuable, append to `docs/KNOWLEDGE.md`:

```markdown
## [Category]
* [YYYY-MM-DD] **[Context]**: [Specific lesson learned]
```

---

## Reflection Template

```markdown
## Plan Deviations
- **[Step X]**: Changed approach because...
- **[Added]**: Added extra step for...
- **[Skipped]**: Skipped step because...
*If none, write "None".*

## Reflection: Task [ID]

### What Went Well
- Point 1
- Point 2

### What Could Improve
- Point 1
- Point 2

### Lessons Learned
- Lesson 1 (→ Added to KNOWLEDGE.md)
- Lesson 2

### Follow-up Actions
- [ ] Update skill X with new pattern
- [ ] Create workflow for process Y
- [ ] Add new ideas to `POTENTIAL-FUTURE-FEATURES.md`

### Potential Future Features
- Idea 1 (→ Added to POTENTIAL-FUTURE-FEATURES.md)
- Idea 2
```

---

## Confidence Thresholds for Actions

| Finding | Confidence | Action |
|---------|------------|--------|
| New skill needed | 80%+ | Trigger skill-creator |
| Process improvement | 80%+ | Trigger workflow-creator |
| Knowledge gap | 60%+ | Add to KNOWLEDGE.md |
| Skill update needed | 70%+ | Update existing skill |

---

## Modes of Operation

### 1. Task Mode (via `/commit-task`)
- **Goal:** Capture granular details while fresh in context.
- **Output:** Append to the specific **Task Document** (`backlog/tasks/task-X.md`).
- **Do NOT** write to `KNOWLEDGE.md` yet (avoids noise).

### 2. Spec Mode (via `/finish-spec`)
- **Goal:** Synthesize high-level patterns from multiple tasks.
- **Input:** Read `backlog/tasks/*.md` to find "Lessons Learned" from Task Mode.
- **Output:** Consolidate and write to **Project Knowledge** (`docs/KNOWLEDGE.md`).

---

## Integration with Workflows

### In `/commit-task`
1. Run self-reflection on the current task.
2. **Record Deviations:** Append `## Plan Deviations` if any.
3. **Record Reflection:** Append `## Reflection` to the bottom of the task markdown file.
4. Changes are staged and committed in the main atomic commit.

### In `/finish-spec`
1. Read all task files associated with the spec.
2. Extract insights from their "Reflection" sections.
3. Filter for project-wide relevance (vs one-off operational details).
4. Append high-value lessons to `docs/KNOWLEDGE.md`.
