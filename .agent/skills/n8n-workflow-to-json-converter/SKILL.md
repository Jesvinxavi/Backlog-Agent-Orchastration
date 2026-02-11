---
name: n8n-workflow-to-json-converter
description: Guide for exporting n8n workflows from a remote Docker container to local JSON files for version control.
---

# n8n Workflow to JSON Converter Skill

Use this skill when you need to backup or version control n8n workflows that are running on a remote server.

## Context
n8n stores workflows in an internal SQLite/Postgres database. To version control them in our git repo, we must export them to JSON using the n8n CLI tools inside the Docker container.

## Prerequisites
- SSH access to the server (e.g., `100.65.190.84`).
- Correct SSH key (usually `keys/jarvis-server.key`).
- n8n running in a Docker container named `n8n`.

## Step-by-Step Procedure

### 1. Identify Workflow ID
If you don't know the ID, export ALL workflows first to find it, or check the n8n UI URL (e.g., `/workflow/<ID>`).

**List all workflows (Dry Run):**
```bash
ssh -i "keys/jarvis-server.key" ubuntu@100.65.190.84 "docker exec -u node n8n n8n export:workflow --all --output=-"
```

### 2. Export Specific Workflow to JSON
Direct redirection (`>`) sometimes fails with SSH due to TTY issues. The most reliable method is a two-step "Export-then-Cat" process.

**Command Syntax:**
```bash
ssh -i "keys/jarvis-server.key" <HOST> "docker exec -u node n8n n8n export:workflow --id <WORKFLOW_ID> --output=/tmp/temp_export.json > /dev/null && docker exec -u node n8n cat /tmp/temp_export.json"
```

**Example (Process Link to Brain):**
```bash
ssh -i "keys/jarvis-server.key" ubuntu@100.65.190.84 "docker exec -u node n8n n8n export:workflow --id skGSR2EjBrl-Oycfh8IFX --output=/tmp/export.json > /dev/null && docker exec -u node n8n cat /tmp/export.json"
```

### 3. Save to Infrastructure Directory
Take the output JSON from step 2 and save it to the local project:

**Target Directory:** `infrastructure/n8n/workflows/`
**Naming Convention:** `<workflow-name-kebab-case>.json`

**Example:**
Create file `infrastructure/n8n/workflows/process-link-to-brain.json` and paste the JSON content.

### 4. Verify JSON
Ensure the JSON is valid and contains the `nodes` and `connections` arrays.
- If the output is wrapped in an array `[...]`, that is fine (n8n default).
- If it's a single object, that is also fine.

## Troubleshooting
- **Permission Denied:** Ensure you are using `-i "keys/jarvis-server.key"`.
- **"No such container":** specific container name might be different. Run `docker ps` on server to check.
- **Empty Output:** Try exporting to `/tmp/` first as shown in Step 2, rather than piping directly to stdout.

## Reference Commands
- **Export All:** `n8n export:workflow --all`
- **Export by ID:** `n8n export:workflow --id <ID>`
- **Import (Restore):** `n8n import:workflow --input=/path/to/file.json`
