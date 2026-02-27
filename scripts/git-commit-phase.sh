#!/bin/bash
# =============================================================================
# Git Commit Phase Script
# =============================================================================
# This script creates a phase branch, stages all changes, commits with a
# formatted message, and pushes to the remote repository.
#
# Usage: ./scripts/git-commit-phase.sh <phase_number> "<commit_message>"
# Example: ./scripts/git-commit-phase.sh 7 "Completed models and admin setup"
# =============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "${RED}Error: Missing arguments${NC}"
    echo ""
    echo -e "${YELLOW}Usage: $0 <phase_number> \"<commit_message>\"${NC}"
    echo -e "${BLUE}Example: $0 7 \"Completed models and admin setup\"${NC}"
    echo ""
    exit 1
fi

PHASE_NUMBER=$1
COMMIT_MESSAGE=$2
PHASE_BRANCH="phase-$PHASE_NUMBER"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Git Commit - Phase $PHASE_NUMBER${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Check if Git repository exists
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not a Git repository${NC}"
    echo -e "${YELLOW}Run 'git init' first${NC}"
    exit 1
fi

# Check if remote is configured
if ! git remote -v | grep -q origin; then
    echo -e "${YELLOW}Warning: No remote 'origin' configured${NC}"
    
    # Check if gh CLI is available
    if command -v gh &> /dev/null; then
        echo -e "${BLUE}GitHub CLI detected. Would you like to create a GitHub repo? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo -e "${YELLOW}Creating GitHub repository...${NC}"
            gh repo create crm --public --source=. --remote=origin --push
            echo -e "${GREEN}✓ GitHub repository created${NC}"
        else
            echo -e "${YELLOW}You can add a remote manually with: git remote add origin <your-repo-url>${NC}"
        fi
    else
        echo -e "${YELLOW}You can add a remote with: git remote add origin <your-repo-url>${NC}"
        echo -e "${YELLOW}Or install GitHub CLI (gh) for automatic repo creation${NC}"
    fi
    echo ""
fi

# Check if branch exists, if not create from master
if git show-ref --verify --quiet refs/heads/"$PHASE_BRANCH"; then
    echo -e "${YELLOW}[1/5] Branch '$PHASE_BRANCH' exists, checking out...${NC}"
    git checkout "$PHASE_BRANCH"
else
    echo -e "${YELLOW}[1/5] Creating branch '$PHASE_BRANCH' from master...${NC}"
    git checkout master
    git pull origin master 2>/dev/null || echo -e "${YELLOW}Warning: Could not pull from remote (this is OK for new branches)${NC}"
    git checkout -b "$PHASE_BRANCH"
fi
echo -e "${GREEN}✓ Now on branch '$PHASE_BRANCH'${NC}"

# Stage all changes
echo -e "${YELLOW}[2/5] Staging all changes...${NC}"
git add .
echo -e "${GREEN}✓ Changes staged${NC}"

# Show what will be committed
echo ""
echo -e "${BLUE}Files to be committed:${NC}"
git status --short
echo ""

# Check if there are changes to commit
if [ -z "$(git status --short)" ]; then
    echo -e "${YELLOW}No changes to commit${NC}"
    exit 0
fi

# Commit with formatted message
echo -e "${YELLOW}[3/5] Committing changes...${NC}"
FULL_MESSAGE="Phase $PHASE_NUMBER: $COMMIT_MESSAGE"
git commit -m "$FULL_MESSAGE"
echo -e "${GREEN}✓ Committed: $FULL_MESSAGE${NC}"

# Push to remote
echo -e "${YELLOW}[4/5] Pushing to remote...${NC}"
if git remote -v | grep -q origin; then
    git push -u origin "$PHASE_BRANCH"
    echo -e "${GREEN}✓ Pushed to origin/$PHASE_BRANCH${NC}"
else
    echo -e "${YELLOW}Skipping push (no remote configured)${NC}"
fi

# Show next steps
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Phase $PHASE_NUMBER Committed Successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Current branch: ${BLUE}$PHASE_BRANCH${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Continue working on Phase $PHASE_NUMBER"
echo -e "  2. When ready, run: ${BLUE}./scripts/git-commit-phase.sh $PHASE_NUMBER \"Additional changes\"${NC}"
echo -e "  3. After finalizing, merge with: ${BLUE}./scripts/git-merge-phase.sh $PHASE_NUMBER${NC}"
echo ""
