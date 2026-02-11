---
name: changelog-manager
description: strictly manages updates to CHANGELOG.md, enforcing date formats and entry structure.
---

# Changelog Manager Skill

Use this skill to safely and consistently update the project `CHANGELOG.md`.

## Core Responsibilities
- **Enforcing Dates:** Every entry must be dated.
- **Formatting:** Entries must follow a strict template.
- **Placement:** Entries must go under `## [Unreleased]`.

---

## 1. Entry Format (Strict)

**Template:**
`- [YYYY-MM-DD] **[Task-<ID>]**: <Summary> (Deviations: <Note or N/A>)`

- **Date:** Always `[YYYY-MM-DD]` (e.g., `[2024-03-25]`).
- **Task ID:** Mandatory. Use `[Task-<ID>]` for backlog tasks, or `[Meta]` / `[Chore]` for general maintenance.
- **Summary:** Brief description of work delivered.
- **Deviations:** Explicitly state "N/A" if none, or list them briefly.

**Examples:**
- ` - [2024-03-25] **[Task-12]**: Implemented user login. (Deviations: N/A)`
- ` - [2024-03-25] **[Task-13]**: Added Stripe webhook. (Deviations: Added explicit signature check)`
- ` - [2024-03-25] **[Meta]**: Updated project documentation. (Deviations: N/A)`

---

## 2. Update Protocol

1.  **Read** `CHANGELOG.md`.
2.  **Locate** the `## [Unreleased]` header.
    - If missing, create it at the top of the file (below title).
3.  **Identify** the correct sub-section (`### Added`, `### Changed`, `### Fixed`).
    - Defaults to `### Added` if unsure or mixed.
    - Create the sub-section if it doesn't exist under `[Unreleased]`.
4.  **Prepend** the new entry to the top of the list in that section.
    - *Why top?* Most recent changes should be first.

---

## 3. Version Release Protocol (Manual Trigger Only)

When the user says "Cut a release" or "Version bump":

1.  Rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD`.
2.  Create a new empty `## [Unreleased]` section above it.
3.  Add `### Added`, `### Changed`, `### Fixed` placeholders.

---

## Verification
- [ ] Date is present and correct?
- [ ] Task ID is bolded?
- [ ] Deviations are explicitly mentioned (even if N/A)?
- [ ] Entry is under `[Unreleased]`?
