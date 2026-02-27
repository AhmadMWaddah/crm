#!/bin/bash
# =============================================================================
# Git Merge Phase Script
# =============================================================================
# This script merges a completed phase branch into master and pushes the result.
# It pulls the latest changes, performs the merge, and optionally deletes the phase branch.
#
# Usage: ./scripts/git-merge-phase.sh <phase_number>
# Example: ./scripts/git-merge-phase.sh 7
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
if [ -z "$1" ]; then
    echo -e "${RED}Error: Missing phase number${NC}"
    echo ""
    echo -e "${YELLOW}Usage: $0 <phase_number>${NC}"
    echo -e "${BLUE}Example: $0 7${NC}"
    echo ""
    exit 1
fi

PHASE_NUMBER=$1
PHASE_BRANCH="phase-$PHASE_NUMBER"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Git Merge - Phase $PHASE_NUMBER${NC}"
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

# Check if phase branch exists
if ! git show-ref --verify --quiet refs/heads/"$PHASE_BRANCH"; then
    echo -e "${RED}Error: Branch '$PHASE_BRANCH' does not exist${NC}"
    echo -e "${YELLOW}Available branches:${NC}"
    git branch
    echo ""
    exit 1
fi

# Check if remote is configured
REMOTE_EXISTS=false
if git remote -v | grep -q origin; then
    REMOTE_EXISTS=true
fi

# Checkout master and pull latest
echo -e "${YELLOW}[1/6] Switching to master branch...${NC}"
git checkout master
echo -e "${GREEN}✓ On branch master${NC}"

if [ "$REMOTE_EXISTS" = true ]; then
    echo -e "${YELLOW}[2/6] Pulling latest changes from remote...${NC}"
    git pull origin master
    echo -e "${GREEN}✓ Master is up to date${NC}"
else
    echo -e "${YELLOW}[2/6] Skipping pull (no remote configured)${NC}"
fi

# Check if phase branch is up to date with remote (if remote exists)
if [ "$REMOTE_EXISTS" = true ]; then
    echo -e "${YELLOW}[3/6] Ensuring phase branch is up to date...${NC}"
    git fetch origin "$PHASE_BRANCH" 2>/dev/null || echo -e "${YELLOW}Warning: Phase branch not on remote${NC}"
fi

# Perform the merge
echo -e "${YELLOW}[4/6] Merging '$PHASE_BRANCH' into master...${NC}"
if git merge "$PHASE_BRANCH" -m "Merge $PHASE_BRANCH into master"; then
    echo -e "${GREEN}✓ Merge successful${NC}"
else
    echo -e "${RED}✗ Merge failed - there are conflicts${NC}"
    echo ""
    echo -e "${YELLOW}To resolve:${NC}"
    echo -e "  1. Fix the merge conflicts manually"
    echo -e "  2. Run: git add <files>"
    echo -e "  3. Run: git commit"
    echo -e "  4. Then run this script again"
    echo ""
    exit 1
fi

# Push master to remote
echo -e "${YELLOW}[5/6] Pushing master to remote...${NC}"
if [ "$REMOTE_EXISTS" = true ]; then
    git push origin master
    echo -e "${GREEN}✓ Master pushed to origin${NC}"
else
    echo -e "${YELLOW}Skipping push (no remote configured)${NC}"
fi

# Ask about deleting the phase branch
echo ""
echo -e "${YELLOW}[6/6] Delete the phase branch '$PHASE_BRANCH'? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Delete local branch
    git branch -d "$PHASE_BRANCH"
    echo -e "${GREEN}✓ Deleted local branch${NC}"

    # Delete remote branch if remote exists
    if [ "$REMOTE_EXISTS" = true ]; then
        if git show-ref --verify --quiet refs/remotes/origin/"$PHASE_BRANCH"; then
            git push origin --delete "$PHASE_BRANCH"
            echo -e "${GREEN}✓ Deleted remote branch${NC}"
        fi
    fi
else
    echo -e "${YELLOW}Keeping branch '$PHASE_BRANCH'${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Phase $PHASE_NUMBER Merged Successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Current branch: ${BLUE}master${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Start working on the next phase"
echo -e "  2. Create a new phase branch with: ${BLUE}./scripts/git-commit-phase.sh <next_phase> \"Description\"${NC}"
echo ""
