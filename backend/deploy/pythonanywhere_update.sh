#!/bin/bash

# PythonAnywhere Update Script
# Run this in a PythonAnywhere Bash console to update your deployment

set -e

echo "🚀 Updating Portfolio Backend on PythonAnywhere"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
PROJECT_DIR="$HOME/portfolio-svelte-django/backend"
VENV_NAME="portfolio-env"

# Navigate to project
echo -e "${BLUE}📁 Navigating to project directory...${NC}"
cd $PROJECT_DIR

# Activate virtual environment
echo -e "${BLUE}🐍 Activating virtual environment...${NC}"
source $HOME/.virtualenvs/$VENV_NAME/bin/activate

# Pull latest changes
echo -e "${BLUE}📥 Pulling latest changes from Git...${NC}"
git pull origin main

# Install/update dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
pip install -r requirements.txt

# Run migrations
echo -e "${BLUE}🗄️  Running database migrations...${NC}"
python manage.py migrate

# Collect static files
echo -e "${BLUE}📁 Collecting static files...${NC}"
python manage.py collectstatic --noinput

# Backup database
echo -e "${BLUE}💾 Creating database backup...${NC}"
mkdir -p $HOME/backups
if [ -f "db.sqlite3" ]; then
    cp db.sqlite3 $HOME/backups/db_$(date +%Y%m%d_%H%M%S).sqlite3
    echo -e "${GREEN}✓ Database backed up${NC}"
fi

echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}✅ Update Complete!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Don't forget to reload your web app!${NC}"
echo ""
echo "Go to: https://www.pythonanywhere.com/user/$(whoami)/webapps/"
echo "Click the big green 'Reload' button"
echo ""
echo "Or reload via API:"
echo "curl -X POST https://www.pythonanywhere.com/api/v0/user/$(whoami)/webapps/$(whoami).pythonanywhere.com/reload/ -H \"Authorization: Token YOUR_API_TOKEN\""
echo ""
