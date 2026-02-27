#!/bin/bash
# =============================================================================
# Test Runner Script
# =============================================================================
# This script runs all tests and pre-commit checks for the Django CRM project.
# It activates the virtual environment, runs Django tests with coverage,
# and executes pre-commit hooks.
#
# Usage: ./scripts/test.sh
#        ./scripts/test.sh --verbose  (for verbose output)
#        ./scripts/test.sh --coverage (to show coverage report)
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
echo -e "${BLUE}  Django CRM - Test Runner${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Check if virtual environment exists
if [ ! -d ".env_crm" ]; then
    echo -e "${RED}Error: Virtual environment '.env_crm' not found.${NC}"
    echo -e "${YELLOW}Please run './scripts/setup.sh' first to set up the project.${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${YELLOW}[1/3] Activating virtual environment...${NC}"
source .env_crm/bin/activate

# Run pre-commit checks
echo -e "${YELLOW}[2/3] Running pre-commit checks...${NC}"
if command -v pre-commit &> /dev/null; then
    if pre-commit run --all-files; then
        echo -e "${GREEN}✓ Pre-commit checks passed${NC}"
    else
        echo -e "${RED}✗ Pre-commit checks failed${NC}"
        echo -e "${YELLOW}Please fix the issues above before committing${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Warning: pre-commit not installed, skipping${NC}"
fi

# Run Django tests
echo -e "${YELLOW}[3/3] Running Django tests...${NC}"
echo ""

# Check for verbose flag
VERBOSE=""
if [[ "$1" == "--verbose" ]] || [[ "$1" == "-v" ]]; then
    VERBOSE="--verbosity=2"
fi

# Check for coverage flag
if [[ "$1" == "--coverage" ]] || [[ "$1" == "-c" ]]; then
    # Install coverage if not present
    pip install coverage &> /dev/null || true

    echo -e "${BLUE}Running tests with coverage...${NC}"
    coverage run --source='.' manage.py test $VERBOSE
    echo ""
    echo -e "${BLUE}Coverage Report:${NC}"
    coverage report
    echo ""
    echo -e "${YELLOW}HTML coverage report available at: htmlcov/index.html${NC}"
    coverage html
else
    python manage.py test $VERBOSE
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  All Tests Passed!${NC}"
echo -e "${GREEN}========================================${NC}"
