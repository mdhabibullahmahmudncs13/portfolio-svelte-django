#!/bin/bash

# VPS Setup Script for Django Portfolio Backend
# Run this script on your VPS as root or with sudo

set -e

echo "🚀 Portfolio Backend - VPS Deployment Setup"
echo "==========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Variables - UPDATE THESE
DOMAIN="your-domain.com"
PROJECT_DIR="/var/www/portfolio"
DB_NAME="portfolio_db"
DB_USER="portfolio_user"
DB_PASSWORD="your-secure-password"  # Change this!
REPO_URL="https://github.com/yourusername/portfolio.git"

echo -e "${BLUE}Step 1: Update system${NC}"
apt update && apt upgrade -y

echo -e "${BLUE}Step 2: Install dependencies${NC}"
apt install -y python3 python3-pip python3-venv \
    postgresql postgresql-contrib \
    nginx \
    git \
    certbot python3-certbot-nginx \
    supervisor

echo -e "${GREEN}✓ Dependencies installed${NC}"

echo -e "${BLUE}Step 3: Setup PostgreSQL${NC}"
sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
ALTER ROLE $DB_USER SET client_encoding TO 'utf8';
ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';
ALTER ROLE $DB_USER SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
\q
EOF

echo -e "${GREEN}✓ PostgreSQL configured${NC}"

echo -e "${BLUE}Step 4: Create project directory${NC}"
mkdir -p $PROJECT_DIR
mkdir -p /var/log/gunicorn
mkdir -p /var/run/gunicorn
chown -R www-data:www-data $PROJECT_DIR
chown -R www-data:www-data /var/log/gunicorn
chown -R www-data:www-data /var/run/gunicorn

echo -e "${BLUE}Step 5: Clone repository${NC}"
cd /var/www
if [ -d "$PROJECT_DIR/.git" ]; then
    cd $PROJECT_DIR
    sudo -u www-data git pull
else
    sudo -u www-data git clone $REPO_URL portfolio
fi

echo -e "${GREEN}✓ Repository cloned${NC}"

echo -e "${BLUE}Step 6: Setup Python virtual environment${NC}"
cd $PROJECT_DIR/backend
sudo -u www-data python3 -m venv venv
sudo -u www-data venv/bin/pip install --upgrade pip
sudo -u www-data venv/bin/pip install -r requirements.txt
sudo -u www-data venv/bin/pip install gunicorn psycopg2-binary

echo -e "${GREEN}✓ Virtual environment setup${NC}"

echo -e "${BLUE}Step 7: Configure environment variables${NC}"
cat > $PROJECT_DIR/backend/.env <<EOF
SECRET_KEY=$(python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
DEBUG=False
ALLOWED_HOSTS=$DOMAIN,www.$DOMAIN
DB_ENGINE=django.db.backends.postgresql
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_HOST=localhost
DB_PORT=5432
CORS_ALLOWED_ORIGINS=https://$DOMAIN,https://www.$DOMAIN
EOF

chown www-data:www-data $PROJECT_DIR/backend/.env
chmod 600 $PROJECT_DIR/backend/.env

echo -e "${GREEN}✓ Environment configured${NC}"

echo -e "${BLUE}Step 8: Run Django migrations${NC}"
cd $PROJECT_DIR/backend
sudo -u www-data venv/bin/python manage.py migrate
sudo -u www-data venv/bin/python manage.py collectstatic --noinput

echo -e "${GREEN}✓ Django setup complete${NC}"

echo -e "${BLUE}Step 9: Configure Nginx${NC}"
cp $PROJECT_DIR/backend/deploy/nginx.conf /etc/nginx/sites-available/portfolio
sed -i "s/your-domain.com/$DOMAIN/g" /etc/nginx/sites-available/portfolio
ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t

echo -e "${GREEN}✓ Nginx configured${NC}"

echo -e "${BLUE}Step 10: Setup systemd service${NC}"
cp $PROJECT_DIR/backend/deploy/portfolio.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable portfolio
systemctl start portfolio

echo -e "${GREEN}✓ Systemd service configured${NC}"

echo -e "${BLUE}Step 11: Setup SSL with Let's Encrypt${NC}"
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

echo -e "${GREEN}✓ SSL certificate installed${NC}"

echo -e "${BLUE}Step 12: Restart services${NC}"
systemctl restart portfolio
systemctl restart nginx

echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "Your backend is now running at: ${BLUE}https://$DOMAIN${NC}"
echo ""
echo "Next steps:"
echo "1. Create superuser: cd $PROJECT_DIR/backend && sudo -u www-data venv/bin/python manage.py createsuperuser"
echo "2. Access admin panel: https://$DOMAIN/admin/"
echo "3. Test API: https://$DOMAIN/api/"
echo ""
echo "Useful commands:"
echo "  - Check service status: sudo systemctl status portfolio"
echo "  - View logs: sudo journalctl -u portfolio -f"
echo "  - Restart service: sudo systemctl restart portfolio"
echo "  - Nginx logs: sudo tail -f /var/log/nginx/portfolio_error.log"
echo ""
