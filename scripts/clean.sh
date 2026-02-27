#!/bin/bash
# =============================================================================
# Cleanup Script
# =============================================================================
# This script removes temporary files, cache directories, and optionally
# the database file for the Django CRM project.
#
# Usage: ./scripts/clean.sh
#        ./scripts/clean.sh --all  (includes database deletion)
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

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Django CRM - Cleanup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Count of items cleaned
CLEANED=0

# Function to clean directory
clean_dir() {
    local dir=$1
    local name=$2

    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Removing $name...${NC}"
        rm -rf "$dir"
        ((CLEANED++)) || true
        echo -e "${GREEN}✓ Removed $name${NC}"
    fi
}

# Function to clean files by pattern
clean_files() {
    local pattern=$1
    local name=$2

    local count=$(find . -name "$pattern" -type f 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
        echo -e "${YELLOW}Removing $name ($count files)...${NC}"
        find . -name "$pattern" -type f -delete
        ((CLEANED++)) || true
        echo -e "${GREEN}✓ Removed $count $name${NC}"
    fi
}

echo -e "${BLUE}Cleaning Python cache...${NC}"

# Remove __pycache__ directories
clean_dir "__pycache__" "__pycache__ directories"
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✓ Removed all __pycache__ directories${NC}"

# Remove .pyc files
clean_files "*.pyc" ".pyc files"

# Remove .pyo files
clean_files "*.pyo" ".pyo files"

# Remove .egg-info directories
clean_dir "*.egg-info" "*.egg-info directories"
find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true

# Remove .pytest_cache
clean_dir ".pytest_cache" ".pytest_cache"

# Remove htmlcov (coverage reports)
clean_dir "htmlcov" "HTML coverage reports"

# Remove .coverage files
clean_files ".coverage" ".coverage files"

# Remove staticfiles (will be regenerated)
clean_dir "staticfiles" "staticfiles directory"

# Check for --all flag to include database
if [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  DANGER ZONE${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""

    # Remove database file
    if [ -f "db.sqlite3" ]; then
        echo -e "${YELLOW}Removing database file (db.sqlite3)...${NC}"
        rm -f db.sqlite3
        echo -e "${GREEN}✓ Database deleted${NC}"
    fi

    # Remove media files
    if [ -d "media" ]; then
        echo -e "${YELLOW}Removing media directory...${NC}"
        rm -rf media
        echo -e "${GREEN}✓ Media directory deleted${NC}"
    fi
else
    echo ""
    echo -e "${YELLOW}Note: Database and media files preserved${NC}"
    echo -e "${YELLOW}Use '${BLUE}./scripts/clean.sh --all${NC}' to remove them${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Cleanup Complete!${NC}"
echo -e "${GREEN}  Items cleaned: $CLEANED${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
