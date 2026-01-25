# Backlog Agent Orchestration (Elite Configuration)

This repository serves as the **"Brain"** for AI Agents in your projects. It contains specialized Skills, Workflows, and Configurations designed to supercharge your development process.

It is designed to be used with the **Backlog.md CLI** tool.

## 🚀 Quick Start

### 1. Install
Run this in your project directory:
```bash
curl -sL https://raw.githubusercontent.com/Jesvinxavi/Backlog-Agent-Orchastration/main/scripts/scaffold-agents.sh | bash
```

### 2. Open the Dashboard
```bash
backlog board
```
This opens a web-based Kanban board showing all your tasks.

### 3. Tell your Agent to use the workflows
Point your AI agent (Claude, Cursor, etc.) to the `.agent/` folder. The agent will read the skills and workflows automatically.

---

## 📋 Backlog.md Quick Reference

| Command | What it does |
|---------|--------------|
| `backlog board` | Open web dashboard (Kanban view) |
| `backlog task list` | List all tasks in terminal |
| `backlog task list --status "To Do"` | Filter by status |
| `backlog task create "My Task"` | Create a new task |
| `backlog task update TASK-1 --status "Done"` | Update task status |
| `backlog search "auth"` | Search tasks and specs |
| `backlog adr create "Use Postgres"` | Create Architecture Decision Record |

---

## ⚡ Workflows (How to Use with Agents)

These are the standardized procedures your agent follows. Invoke them by name.

| Workflow | When to Use | What it Does |
|----------|-------------|--------------|
| `/create-project-spec` | Starting a NEW project | Deep interview → PRD → Tech Spec → Architecture |
| `/create-task-spec` | Adding a new feature | Idea → Spec → Decomposed Tasks |
| `/start-task` | Beginning work on a task | Creates branch, updates status, loads context |
| `/commit-task` | Ready to commit code | Runs checks, creates commit, updates task |
| `/finish-spec` | Completing a feature | Quality gate → Merge → Update backlog |

### Example Usage
Tell your agent:
> "Use /create-task-spec to spec out a user authentication feature"

Or:
> "Run /start-task for TASK-5"

---

## 🔄 Development Lifecycle

### 1. Scaffold
Run the install command. This copies the "Brain" into your project.

### 2. Evolve
As you work, improve the skills/workflows directly in your project.

### 3. Sync Back
Push improvements back to this central repo:
```bash
./.agent/.source-repo/scripts/sync-upstream.sh /path/to/your/agent-skills-repo
```

---

## 🛠️ Architecture

| Component | Location | Purpose |
|-----------|----------|---------|
| **Skills** | `.agent/skills/*` | Specialized agent roles (CTO, QA Lead, etc.) |
| **Workflows** | `.agent/workflows/*` | Step-by-step procedures |
| **Config** | `backlog/config.yml` | Backlog.md settings |
| **Knowledge** | `backlog/KNOWLEDGE.md` | Project-specific learnings |
| **Templates** | `backlog/templates/*` | Task/spec templates |

---

## 📦 Dependencies

* **Tool**: `backlog` CLI
* **Package**: `backlog.md` (NPM)
* **Source**: [GitHub - MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md)

The install script automatically installs the CLI if missing.
