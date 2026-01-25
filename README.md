# Backlog Agent Orchestration (Elite Configuration)

This repository serves as the **"Brain"** for AI Agents in your projects. It contains specialized Skills, Workflows, and Configurations designed to supercharge your development process.

It is designed to be used with the **Backlog.md CLI** tool.

## 🚀 Usage (Start Here)

To install these skills into a new or existing project, run the installation script:

```bash
# Installs Backlog.md CLI + This Configuration
curl -sL https://raw.githubusercontent.com/Jesvinxavi/Backlog-Agent-Orchastration/main/scripts/scaffold-agents.sh | bash
```

### After Installation
```bash
# Open the web dashboard (Kanban board)
backlog board
```

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

The system is designed to evolve. **You do not need to edit this repo directly.** Instead, you improve the system while working on your actual projects, then sync the Best Practices back here.

### 1. Scaffold
Run the install command in your new project. This copies the "Brain" (Skills, Workflows) into your project structure.

### 2. Evolve
As you work on your project, you might find a better way to do something.
**Edit the files directly in your project** (e.g., Update `.agent/skills/frontend-mastery.md` or refine `.agent/workflows/create-task.md`).

### 3. Sync Back (Contribute)
When you have improvements you want to save for *future* projects, run the sync script **from your project**:

```bash
# Syncs YOUR project's improvements back to this central repo
./.agent/.source-repo/scripts/sync-upstream.sh /path/to/local/agent-skills-repo
```

Then, go to your local `agent-skills` repo, commit, and push the changes.

---

## 🛠️ Architecture Overview

*   **The Installer** (`scripts/scaffold-agents.sh`): 
    *   Checks dependencies (Node, Git).
    *   Installs the `backlog` CLI if missing.
    *   Smartly merges configurations (keeps your customizations).
    *   Seeds the project with "Starter Knowledge".

*   **The Skills** (`.agent/skills/*`): 
    *   Specialized instructions that give the agent "Roles" (e.g., `project-decomposer` acts as a CTO, `quality-gate` acts as a QA Lead).

*   **The Workflows** (`.agent/workflows/*`): 
    *   Standardized procedures for complex tasks. They ensure consistency (e.g., "Always audit before merging").

*   **The Configuration** (`backlog/config.yml`): 
    *   Optimized settings for the Backlog.md tool, tuned for Agentic workflows.

---

## 📦 Dependencies

This configuration relies on the **Backlog.md** command-line tool.

*   **Tool**: `backlog` (CLI)
*   **Package**: `backlog.md` (NPM)
*   **Source**: [GitHub - MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md)

The installation script automatically handles the installation of the CLI tool (`npm install -g backlog.md`) if it is not already present.
