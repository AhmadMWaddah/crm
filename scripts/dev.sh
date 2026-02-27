#!/bin/bash
# =============================================================================
# Development Server Script
# =============================================================================
# This script runs the Django development server with all necessary setup.
# It activates the virtual environment, runs migrations, collects static files,
# and starts the server.
#
# Usage: ./scripts/dev.sh
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
echo -e "${BLUE}  Django CRM - Development Server${NC}"
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
echo -e "${YELLOW}[1/4] Activating virtual environment...${NC}"
source .env_crm/bin/activate

# Run migrations
echo -e "${YELLOW}[2/4] Running database migrations...${NC}"
python manage.py migrate

# Collect static files (skip --clear for faster development)
echo -e "${YELLOW}[3/4] Collecting static files...${NC}"
python manage.py collectstatic --noinput

# Start development server
echo -e "${YELLOW}[4/4] Starting development server...${NC}"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Server is running!${NC}"
echo -e "${GREEN}  URL: http://127.0.0.1:8000/${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

python manage.py runserver
