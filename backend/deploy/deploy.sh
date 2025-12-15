#!/bin/bash

# Deployment script for updating the application on VPS
# Run this locally to deploy changes to your VPS

set -e

# Configuration - UPDATE THESE
VPS_HOST="user@your-vps-ip"
VPS_DIR="/var/www/portfolio"

echo "🚀 Deploying to VPS..."
echo ""

# Build and push
echo "📦 Pushing changes to repository..."
git add .
git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
git push origin main

# Deploy on VPS
echo "🔄 Pulling changes on VPS..."
ssh $VPS_HOST << 'ENDSSH'
cd /var/www/portfolio
sudo -u www-data git pull origin main
cd backend
sudo -u www-data venv/bin/pip install -r requirements.txt
sudo -u www-data venv/bin/python manage.py migrate
sudo -u www-data venv/bin/python manage.py collectstatic --noinput
sudo systemctl restart portfolio
sudo systemctl restart nginx
ENDSSH

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your site is live at: https://your-domain.com"
