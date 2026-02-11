#!/bin/bash

# SYNC UPSTREAM SCRIPT
# usage: ./scripts/sync-upstream.sh <path-to-target-repo>
# example: ./scripts/sync-upstream.sh ../Backlog-Agent-Orchestration

TARGET_REPO=$1

if [ -z "$TARGET_REPO" ]; then
    echo "Usage: ./scripts/sync-upstream.sh <path-to-target-repo>"
    exit 1
fi

if [ ! -d "$TARGET_REPO" ]; then
    echo "Error: Target directory '$TARGET_REPO' does not exist."
    exit 1
fi

echo "🚀 Syncing skills and workflows to $TARGET_REPO..."

# ==============================================================================
# 1. Sync Files
# ==============================================================================

echo "📂 Copying files..."

# Sync Skills (delete extraneous in target to keep clean)
rsync -av --delete --exclude '.DS_Store' .agent/skills/ "$TARGET_REPO/.agent/skills/"

# Sync Workflows
rsync -av --delete --exclude '.DS_Store' .agent/workflows/ "$TARGET_REPO/.agent/workflows/"

# Sync Config & Templates
cp backlog/config.yml "$TARGET_REPO/backlog/config.yml"
cp backlog/AGENTS.md "$TARGET_REPO/backlog/AGENTS.md"

# Sync Templates directory
rsync -av --delete --exclude '.DS_Store' backlog/templates/ "$TARGET_REPO/backlog/templates/"

# Sync System Docs
mkdir -p "$TARGET_REPO/backlog/docs"
cp backlog/docs/SKILLS-SYSTEM.md "$TARGET_REPO/backlog/docs/SKILLS-SYSTEM.md"
# Optional: Sync KNOWLEDGE-STARTER if it exists
if [ -f "backlog/docs/KNOWLEDGE-STARTER.md" ]; then
    cp backlog/docs/KNOWLEDGE-STARTER.md "$TARGET_REPO/backlog/docs/KNOWLEDGE-STARTER.md"
fi

# ==============================================================================
# 2. Sanitize Config
# ==============================================================================
echo "🧹 Sanitizing config.yml..."
# Replace project name with generic template name using Mac-compatible sed
sed -i '' 's/project_name: ".*"/project_name: "Agent-Template"/' "$TARGET_REPO/backlog/config.yml"

# Replace project-specific milestones with generic ones
# Use perl for multi-line replacement of the milestones array
perl -i -0777 -pe 's/milestones: \[.*?\]/milestones: ["Phase 1: Foundation", "Phase 2: MVP"]/gs' "$TARGET_REPO/backlog/config.yml"


# ==============================================================================
# 3. Sanitize Task Decomposer (Remove Project-Specific Context)
# ==============================================================================
echo "🧹 Sanitizing task-decomposer skill..."
SKILL_FILE="$TARGET_REPO/.agent/skills/task-decomposer/SKILL.md"

# Remove the block from "## Project-Specific Context: JezOS" up to "## Anti-Patterns"
# Using perl for reliable multi-line replacement
perl -i -0777 -pe 's/## Project-Specific Context: JezOS.*?(?=## Anti-Patterns)//gs' "$SKILL_FILE"

# ==============================================================================
# 4. Standardize Paths (backlog/specs -> docs/)
# ==============================================================================
echo "❤️  Standardizing paths to 'docs/' structure..."

# Define files that need path updates
FILES_TO_UPDATE=(
    "$TARGET_REPO/.agent/skills/project-decomposer/SKILL.md"
    "$TARGET_REPO/.agent/skills/task-decomposer/SKILL.md"
    "$TARGET_REPO/.agent/workflows/create-project-spec.md"
)

for FILE in "${FILES_TO_UPDATE[@]}"; do
    if [ -f "$FILE" ]; then
        echo "   Processing $FILE..."
        
        # 1. Replace base path
        sed -i '' 's|backlog/specs/project/|docs/|g' "$FILE"
        
        # 2. Correct specific file paths to subdirectories
        # PRD -> docs/planning/PRD.md
        sed -i '' 's|`docs/PRD.md`|`docs/planning/PRD.md`|g' "$FILE"
        sed -i '' 's|docs/PRD.md|docs/planning/PRD.md|g' "$FILE"
        
        # TECH-SPEC -> docs/architecture/TECH-SPEC.md
        sed -i '' 's|`docs/TECH-SPEC.md`|`docs/architecture/TECH-SPEC.md`|g' "$FILE"
        sed -i '' 's|docs/TECH-SPEC.md|docs/architecture/TECH-SPEC.md|g' "$FILE"
        
        # ARCHITECTURE -> docs/architecture/ARCHITECTURE.md
        sed -i '' 's|`docs/ARCHITECTURE.md`|`docs/architecture/ARCHITECTURE.md`|g' "$FILE"
        sed -i '' 's|docs/ARCHITECTURE.md|docs/architecture/ARCHITECTURE.md|g' "$FILE"
        
        # IMPLEMENTATION-PLAN -> docs/planning/IMPLEMENTATION-PLAN.md
        sed -i '' 's|`docs/IMPLEMENTATION-PLAN.md`|`docs/planning/IMPLEMENTATION-PLAN.md`|g' "$FILE"
        sed -i '' 's|docs/IMPLEMENTATION-PLAN.md|docs/planning/IMPLEMENTATION-PLAN.md|g' "$FILE"
        
        # POTENTIAL-FUTURE-FEATURES -> docs/planning/POTENTIAL-FUTURE-FEATURES.md
        sed -i '' 's|`docs/POTENTIAL-FUTURE-FEATURES.md`|`docs/planning/POTENTIAL-FUTURE-FEATURES.md`|g' "$FILE"
        sed -i '' 's|docs/POTENTIAL-FUTURE-FEATURES.md|docs/planning/POTENTIAL-FUTURE-FEATURES.md|g' "$FILE"
        
        # 3. Beautify headers in project-decomposer (Specific logic)
        sed -i '' 's|### 1. PRD.md|### 1. `docs/planning/PRD.md`|g' "$FILE"
        sed -i '' 's|### 2. TECH-SPEC.md|### 2. `docs/architecture/TECH-SPEC.md`|g' "$FILE"
        sed -i '' 's|### 3. ARCHITECTURE.md|### 3. `docs/architecture/ARCHITECTURE.md`|g' "$FILE"
        sed -i '' 's|### 4. IMPLEMENTATION-PLAN.md|### 4. `docs/planning/IMPLEMENTATION-PLAN.md`|g' "$FILE"
        sed -i '' 's|### 5. POTENTIAL-FUTURE-FEATURES.md|### 5. `docs/planning/POTENTIAL-FUTURE-FEATURES.md`|g' "$FILE"

        # 4. Handle list items in create-project-spec (Specific logic)
        sed -i '' 's|- `PRD.md`|- `docs/planning/PRD.md`|g' "$FILE"
        sed -i '' 's|- `TECH-SPEC.md`|- `docs/architecture/TECH-SPEC.md`|g' "$FILE"
        sed -i '' 's|- `ARCHITECTURE.md`|- `docs/architecture/ARCHITECTURE.md`|g' "$FILE"
        sed -i '' 's|- `IMPLEMENTATION-PLAN.md`|- `docs/planning/IMPLEMENTATION-PLAN.md`|g' "$FILE"
        sed -i '' 's|- `POTENTIAL-FUTURE-FEATURES.md`|- `docs/planning/POTENTIAL-FUTURE-FEATURES.md`|g' "$FILE"
    fi
done

# ==============================================================================
# 5. Copy Scripts (Updated Scaffold)
# ==============================================================================
echo "📜 Syncing scripts..."
rm -rf "$TARGET_REPO/scripts"
mkdir -p "$TARGET_REPO/scripts"
cp -R scripts/* "$TARGET_REPO/scripts/"

echo "✅ Sync Complete! Review changes in $TARGET_REPO before pushing."
