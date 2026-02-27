#!/bin/bash
# =============================================================================
# Project Setup Script
# =============================================================================
# This script sets up the Django CRM project from scratch.
# It creates the virtual environment, installs dependencies, sets up pre-commit,
# runs migrations, and optionally creates a superuser.
#
# Usage: ./scripts/setup.sh
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
echo -e "${BLUE}  Django CRM - Project Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Check if virtual environment exists
if [ ! -d ".env_crm" ]; then
    echo -e "${YELLOW}[1/6] Creating virtual environment '.env_crm'...${NC}"
    python3 -m venv .env_crm
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}"
fi

# Activate virtual environment
echo -e "${YELLOW}[2/6] Activating virtual environment...${NC}"
source .env_crm/bin/activate

# Install dependencies
echo -e "${YELLOW}[3/6] Installing dependencies...${NC}"
if [ -f "requirements.txt" ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${RED}Error: requirements.txt not found${NC}"
    echo -e "${YELLOW}Please create requirements.txt first${NC}"
    exit 1
fi

# Install pre-commit hooks
echo -e "${YELLOW}[4/6] Installing pre-commit hooks...${NC}"
if [ -f ".pre-commit-config.yaml" ]; then
    pre-commit install
    echo -e "${GREEN}✓ Pre-commit hooks installed${NC}"
else
    echo -e "${YELLOW}Warning: .pre-commit-config.yaml not found, skipping pre-commit${NC}"
fi

# Run migrations
echo -e "${YELLOW}[5/6] Running database migrations...${NC}"
python manage.py migrate
echo -e "${GREEN}✓ Migrations completed${NC}"

# Create superuser (optional)
echo ""
echo -e "${YELLOW}[6/6] Create superuser? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${BLUE}Creating superuser...${NC}"
    python manage.py createsuperuser
    echo -e "${GREEN}✓ Superuser created${NC}"
else
    echo -e "${YELLOW}Skipping superuser creation${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Run '${BLUE}./scripts/dev.sh${NC}' to start the development server"
echo -e "  2. Visit ${BLUE}http://127.0.0.1:8000/admin${NC} to access the admin panel"
echo ""
