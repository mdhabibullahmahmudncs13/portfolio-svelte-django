# VPS Deployment Guide - Django Portfolio Backend

Complete guide for deploying your Django portfolio backend to a VPS (Ubuntu/Debian).

---

## 📋 Prerequisites

- VPS with Ubuntu 20.04+ or Debian 11+
- Domain name pointed to your VPS IP
- Root or sudo access
- Git repository with your code

---

## 🚀 Quick Deployment

### Step 1: Prepare VPS

SSH into your VPS:
```bash
ssh root@your-vps-ip
```

### Step 2: Update Configuration Files

Before running the setup script, update these values:

**In `backend/deploy/setup_vps.sh`:**
```bash
DOMAIN="your-domain.com"
DB_PASSWORD="your-secure-password"
REPO_URL="https://github.com/yourusername/portfolio.git"
```

**In `backend/.env.production`:**
```env
SECRET_KEY=<generate-new-key>
ALLOWED_HOSTS=your-domain.com,www.your-domain.com,your-vps-ip
DB_PASSWORD=<same-as-setup-script>
CORS_ALLOWED_ORIGINS=https://your-domain.com
```

### Step 3: Run Automated Setup

```bash
# Copy setup script to VPS
scp backend/deploy/setup_vps.sh root@your-vps-ip:/tmp/

# SSH to VPS and run
ssh root@your-vps-ip
chmod +x /tmp/setup_vps.sh
bash /tmp/setup_vps.sh
```

### Step 4: Create Superuser

```bash
cd /var/www/portfolio/backend
sudo -u www-data venv/bin/python manage.py createsuperuser
```

### Step 5: Test Deployment

```bash
# Check service status
sudo systemctl status portfolio

# Test API
curl https://your-domain.com/api/

# Access admin panel
https://your-domain.com/admin/
```

---

## 🔧 Manual Deployment

If you prefer manual setup or the automated script fails:

### 1. Install System Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Python and dependencies
sudo apt install -y python3 python3-pip python3-venv

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Install Nginx
sudo apt install -y nginx

# Install SSL certificate tool
sudo apt install -y certbot python3-certbot-nginx

# Install Git
sudo apt install -y git
```

### 2. Setup PostgreSQL

```bash
# Switch to postgres user
sudo -u postgres psql

# Create database and user
CREATE DATABASE portfolio_db;
CREATE USER portfolio_user WITH PASSWORD 'your-secure-password';
ALTER ROLE portfolio_user SET client_encoding TO 'utf8';
ALTER ROLE portfolio_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE portfolio_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE portfolio_db TO portfolio_user;
\q
```

### 3. Setup Project Directory

```bash
# Create directories
sudo mkdir -p /var/www/portfolio
sudo mkdir -p /var/log/gunicorn
sudo mkdir -p /var/run/gunicorn

# Set permissions
sudo chown -R www-data:www-data /var/www/portfolio
sudo chown -R www-data:www-data /var/log/gunicorn
sudo chown -R www-data:www-data /var/run/gunicorn
```

### 4. Clone Repository

```bash
cd /var/www
sudo -u www-data git clone https://github.com/yourusername/portfolio.git
cd portfolio/backend
```

### 5. Setup Virtual Environment

```bash
sudo -u www-data python3 -m venv venv
sudo -u www-data venv/bin/pip install --upgrade pip
sudo -u www-data venv/bin/pip install -r requirements.txt
sudo -u www-data venv/bin/pip install gunicorn psycopg2-binary
```

### 6. Configure Environment

```bash
# Copy production env file
sudo -u www-data cp .env.production .env

# Edit with your values
sudo nano .env

# Generate new SECRET_KEY
python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### 7. Run Django Setup

```bash
# Run migrations
sudo -u www-data venv/bin/python manage.py migrate

# Collect static files
sudo -u www-data venv/bin/python manage.py collectstatic --noinput

# Create superuser
sudo -u www-data venv/bin/python manage.py createsuperuser
```

### 8. Configure Gunicorn

Copy the gunicorn config and systemd service:
```bash
# Copy systemd service
sudo cp deploy/portfolio.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start service
sudo systemctl enable portfolio
sudo systemctl start portfolio

# Check status
sudo systemctl status portfolio
```

### 9. Configure Nginx

```bash
# Copy nginx config
sudo cp deploy/nginx.conf /etc/nginx/sites-available/portfolio

# Update domain name
sudo nano /etc/nginx/sites-available/portfolio

# Enable site
sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx
```

### 10. Setup SSL Certificate

```bash
# Get SSL certificate from Let's Encrypt
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal is configured automatically
# Test renewal
sudo certbot renew --dry-run
```

---

## 📊 System Architecture

```
Internet
    ↓
Nginx (Port 80/443)
    ↓ (proxy_pass)
Gunicorn (Port 8000)
    ↓
Django Application
    ↓
PostgreSQL Database
```

---

## 🔍 Useful Commands

### Service Management

```bash
# Check service status
sudo systemctl status portfolio

# Start service
sudo systemctl start portfolio

# Stop service
sudo systemctl stop portfolio

# Restart service
sudo systemctl restart portfolio

# View logs
sudo journalctl -u portfolio -f
```

### Nginx Management

```bash
# Test configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx

# View error logs
sudo tail -f /var/log/nginx/portfolio_error.log

# View access logs
sudo tail -f /var/log/nginx/portfolio_access.log
```

### Database Management

```bash
# Backup database
sudo -u postgres pg_dump portfolio_db > backup_$(date +%Y%m%d).sql

# Restore database
sudo -u postgres psql portfolio_db < backup_20251215.sql

# Access PostgreSQL
sudo -u postgres psql portfolio_db
```

### Application Updates

```bash
# Pull latest code
cd /var/www/portfolio
sudo -u www-data git pull

# Update dependencies
cd backend
sudo -u www-data venv/bin/pip install -r requirements.txt

# Run migrations
sudo -u www-data venv/bin/python manage.py migrate

# Collect static files
sudo -u www-data venv/bin/python manage.py collectstatic --noinput

# Restart service
sudo systemctl restart portfolio
```

---

## 🛡️ Security Checklist

- [x] Change default `SECRET_KEY`
- [x] Set `DEBUG = False`
- [x] Configure `ALLOWED_HOSTS`
- [x] Use strong database password
- [x] Enable HTTPS with SSL certificate
- [x] Configure firewall (ufw)
- [x] Set proper file permissions
- [x] Regular system updates
- [x] Enable automatic security updates
- [x] Configure fail2ban (optional)
- [x] Regular database backups

### Configure Firewall

```bash
# Enable firewall
sudo ufw enable

# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Check status
sudo ufw status
```

---

## 🔄 CI/CD Deployment

For automated deployments, use the included `deploy.sh` script:

```bash
# Make executable
chmod +x backend/deploy/deploy.sh

# Update VPS_HOST in the script
nano backend/deploy/deploy.sh

# Deploy
./backend/deploy/deploy.sh
```

---

## 🐛 Troubleshooting

### Service Won't Start

```bash
# Check logs
sudo journalctl -u portfolio -n 50

# Check gunicorn config
sudo -u www-data /var/www/portfolio/backend/venv/bin/gunicorn --check-config portfolio_backend.wsgi:application

# Test Django
cd /var/www/portfolio/backend
sudo -u www-data venv/bin/python manage.py check
```

### Database Connection Issues

```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Test connection
sudo -u postgres psql -d portfolio_db -U portfolio_user

# Check DATABASE settings in .env
```

### Static Files Not Loading

```bash
# Recollect static files
cd /var/www/portfolio/backend
sudo -u www-data venv/bin/python manage.py collectstatic --noinput

# Check permissions
ls -la /var/www/portfolio/staticfiles/

# Check nginx configuration
sudo nginx -t
```

### SSL Certificate Issues

```bash
# Renew certificate
sudo certbot renew

# Check certificate status
sudo certbot certificates

# Test renewal
sudo certbot renew --dry-run
```

---

## 📈 Performance Optimization

### Enable Gzip Compression

Add to nginx config:
```nginx
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_types text/plain text/css text/xml text/javascript application/json application/javascript application/xml+rss;
```

### Database Connection Pooling

Install pgbouncer:
```bash
sudo apt install pgbouncer
```

### Caching

Add Redis for caching:
```bash
sudo apt install redis-server
pip install django-redis
```

---

## 📞 Support

For issues:
1. Check service logs: `sudo journalctl -u portfolio -f`
2. Check nginx logs: `sudo tail -f /var/log/nginx/portfolio_error.log`
3. Review Django logs in `/var/log/gunicorn/`

---

**Deployment Guide v1.0** | Last Updated: December 2025
