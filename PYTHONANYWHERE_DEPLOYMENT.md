# PythonAnywhere Deployment Guide - Django Portfolio Backend

Complete guide for deploying and managing your Django portfolio on PythonAnywhere.

---

## 🌐 Your Current Deployment

**API URL**: https://mdhabibullahmahmudncs.pythonanywhere.com/api/
**Admin Panel**: https://mdhabibullahmahmudncs.pythonanywhere.com/admin/

**Note**: PythonAnywhere only supports Python applications (Django backend). Deploy your SvelteKit frontend on Vercel/Netlify. See [FRONTEND_DEPLOYMENT.md](FRONTEND_DEPLOYMENT.md) for frontend deployment.

---

## 📋 Prerequisites

- PythonAnywhere account (Free or Paid)
- Your Django project on GitHub
- Database credentials (if using external DB)

---

## 🚀 Initial Deployment

### Step 1: Clone Repository

```bash
# Open Bash console on PythonAnywhere
cd ~
git clone https://github.com/yourusername/portfolio-svelte-django.git
cd portfolio-svelte-django/backend
```

### Step 2: Create Virtual Environment

```bash
# Create virtual environment
mkvirtualenv --python=/usr/bin/python3.10 portfolio-env

# Install dependencies
pip install -r requirements.txt
```

### Step 3: Configure Environment Variables

```bash
# Create .env file
nano .env
```

Add:
```env
SECRET_KEY=your-production-secret-key
DEBUG=False
ALLOWED_HOSTS=mdhabibullahmahmudncs.pythonanywhere.com
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.com
```

Generate SECRET_KEY:
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### Step 4: Setup Database

```bash
# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Collect static files
python manage.py collectstatic --noinput
```

### Step 5: Configure Web App

1. Go to **Web** tab on PythonAnywhere
2. Click **Add a new web app**
3. Choose **Manual configuration** (Python 3.10)
4. Click through the wizard

### Step 6: Configure WSGI File

Edit the WSGI configuration file:

```python
# /var/www/mdhabibullahmahmudncs_pythonanywhere_com_wsgi.py

import os
import sys
from pathlib import Path

# Add your project directory to the sys.path
path = '/home/mdhabibullahmahmudncs/portfolio-svelte-django/backend'
if path not in sys.path:
    sys.path.insert(0, path)

# Set environment variables
os.environ['DJANGO_SETTINGS_MODULE'] = 'portfolio_backend.settings'

# Load .env file
from pathlib import Path
env_path = Path('/home/mdhabibullahmahmudncs/portfolio-svelte-django/backend/.env')
if env_path.exists():
    from decouple import Config, RepositoryEnv
    config = Config(RepositoryEnv(env_path))

# Initialize Django
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

### Step 7: Configure Static/Media Files

In **Web** tab, set:

**Static files:**
```
URL: /static/
Directory: /home/mdhabibullahmahmudncs/portfolio-svelte-django/backend/staticfiles/
```

**Media files:**
```
URL: /media/
Directory: /home/mdhabibullahmahmudncs/portfolio-svelte-django/backend/media/
```

### Step 8: Configure Virtual Environment

In **Web** tab, set virtualenv path:
```
/home/mdhabibullahmahmudncs/.virtualenvs/portfolio-env
```

### Step 9: Reload Web App

Click the big green **Reload** button!

---

## 🔄 Updating Deployment

### Quick Update Script

Create `update.sh` in your project:

```bash
#!/bin/bash

# PythonAnywhere Quick Update Script

cd ~/portfolio-svelte-django/backend

echo "📥 Pulling latest changes..."
git pull origin main

echo "📦 Installing dependencies..."
workon portfolio-env
pip install -r requirements.txt

echo "🗄️ Running migrations..."
python manage.py migrate

echo "📁 Collecting static files..."
python manage.py collectstatic --noinput

echo "🔄 Reloading web app..."
# You need to manually reload via web interface or use PA API

echo "✅ Update complete!"
echo "🌐 Don't forget to reload the web app in PythonAnywhere Web tab!"
```

Make it executable:
```bash
chmod +x update.sh
```

### Manual Update Steps

```bash
# 1. Navigate to project
cd ~/portfolio-svelte-django/backend

# 2. Activate virtual environment
workon portfolio-env

# 3. Pull latest code
git pull origin main

# 4. Update dependencies
pip install -r requirements.txt

# 5. Run migrations
python manage.py migrate

# 6. Collect static files
python manage.py collectstatic --noinput

# 7. Reload web app (Web tab → Reload button)
```

---

## 🗄️ Database Management

### Using SQLite (Default)

```bash
# Backup database
cp ~/portfolio-svelte-django/backend/db.sqlite3 ~/backups/db_$(date +%Y%m%d).sqlite3

# Restore database
cp ~/backups/db_20251215.sqlite3 ~/portfolio-svelte-django/backend/db.sqlite3
```

### Using MySQL (Recommended for Free Tier)

PythonAnywhere provides free MySQL database:

1. Go to **Databases** tab
2. Create MySQL database
3. Note your credentials

Update `.env`:
```env
DB_ENGINE=django.db.backends.mysql
DB_NAME=mdhabibullahmahmudncs$portfolio
DB_USER=mdhabibullahmahmudncs
DB_PASSWORD=your-mysql-password
DB_HOST=mdhabibullahmahmudncs.mysql.pythonanywhere-services.com
DB_PORT=3306
```

Update `requirements.txt`:
```txt
mysqlclient>=2.2.0
```

Migrate data:
```bash
# Dump data from SQLite
python manage.py dumpdata --exclude auth.permission --exclude contenttypes > data.json

# Switch to MySQL in .env
# Run migrations
python manage.py migrate

# Load data
python manage.py loaddata data.json
```

---

## 📊 PythonAnywhere Settings

### Update settings.py for PythonAnywhere

The current `settings.py` already supports PythonAnywhere with:
- Dynamic `ALLOWED_HOSTS` from environment
- PostgreSQL/MySQL/SQLite support
- CORS configuration
- Static/Media file handling

Ensure `.env` has:
```env
SECRET_KEY=<your-secret-key>
DEBUG=False
ALLOWED_HOSTS=mdhabibullahmahmudncs.pythonanywhere.com
CORS_ALLOWED_ORIGINS=https://your-frontend.vercel.app,https://your-domain.com
```

---

## 🔍 Debugging on PythonAnywhere

### View Error Logs

**Server Log:**
- Web tab → Log files → Server log

**Error Log:**
- Web tab → Log files → Error log

### Common Issues

**1. Import Errors**
```bash
# Check Python version
python --version

# Verify virtualenv
workon portfolio-env
which python
pip list
```

**2. Static Files Not Loading**
```bash
# Recollect static files
python manage.py collectstatic --noinput

# Check Web tab static files configuration
# Verify paths match actual directories
```

**3. Database Locked**
```bash
# If using SQLite and getting "database is locked"
# Consider switching to MySQL (free on PythonAnywhere)
```

**4. CORS Errors**
```bash
# Check CORS_ALLOWED_ORIGINS in .env
# Must match your frontend domain exactly
```

### Test API from Console

```bash
workon portfolio-env
cd ~/portfolio-svelte-django/backend

# Test Django
python manage.py check

# Test database
python manage.py dbshell

# Test imports
python manage.py shell
>>> from api.models import Skill
>>> Skill.objects.all()
```

---

## 📁 File Structure on PythonAnywhere

```
/home/mdhabibullahmahmudncs/
├── portfolio-svelte-django/
│   └── backend/
│       ├── manage.py
│       ├── .env
│       ├── db.sqlite3
│       ├── api/
│       ├── portfolio_backend/
│       ├── media/
│       └── staticfiles/
├── .virtualenvs/
│   └── portfolio-env/
└── backups/
    └── db_backups/
```

---

## 🔐 Security Best Practices

### 1. Secure Your .env File

```bash
chmod 600 ~/portfolio-svelte-django/backend/.env
```

### 2. Generate Strong SECRET_KEY

```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### 3. Set DEBUG=False

Always use `DEBUG=False` in production!

### 4. Configure ALLOWED_HOSTS

```env
ALLOWED_HOSTS=mdhabibullahmahmudncs.pythonanywhere.com
```

### 5. Use HTTPS Only

Update frontend to use `https://` not `http://`

---

## 📈 Performance Tips

### 1. Use MySQL Instead of SQLite

SQLite has limitations on PythonAnywhere:
- Slower for concurrent requests
- Database locking issues
- MySQL is free and faster

### 2. Optimize Database Queries

```python
# Use select_related and prefetch_related
skills = Skill.objects.select_related('category').all()
```

### 3. Enable Browser Caching

Static files already have caching configured in your nginx setup.

### 4. Compress Static Files

```bash
pip install whitenoise[brotli]
```

Add to `settings.py`:
```python
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
```

---

## 🔄 Scheduled Tasks

PythonAnywhere allows scheduled tasks (cron jobs):

### Backup Database Daily

Go to **Tasks** tab, add:

```bash
#!/bin/bash
cd ~/portfolio-svelte-django/backend
workon portfolio-env
python manage.py dumpdata --indent 2 > ~/backups/backup_$(date +\%Y\%m\%d).json
```

Schedule: `Daily at 02:00 UTC`

### Clean Old Backups

```bash
#!/bin/bash
find ~/backups/ -name "backup_*.json" -mtime +30 -delete
```

---

## 🌐 Custom Domain (Paid Plans)

For paid PythonAnywhere accounts:

1. Go to **Web** tab
2. Click **Add** next to custom domains
3. Add your domain (e.g., `api.yourdomain.com`)
4. Point your domain's CNAME to PythonAnywhere
5. Reload web app

---

## 📞 PythonAnywhere API (Automated Reload)

Install PA client:
```bash
pip install pythonanywhere
```

Create reload script:
```python
# reload_webapp.py
from pythonanywhere.api import Webapp
import os

domain = 'mdhabibullahmahmudncs.pythonanywhere.com'
token = os.environ.get('PA_API_TOKEN')

webapp = Webapp(domain, token)
webapp.reload()
print(f'✅ {domain} reloaded!')
```

Get API token from **Account** tab.

---

## 💡 Quick Reference

### Essential Commands

```bash
# Activate environment
workon portfolio-env

# Update code
cd ~/portfolio-svelte-django/backend && git pull

# Migrations
python manage.py migrate

# Static files
python manage.py collectstatic --noinput

# Create superuser
python manage.py createsuperuser

# Django shell
python manage.py shell

# Check for issues
python manage.py check
```

### Important URLs

- **Web App Config**: https://www.pythonanywhere.com/user/mdhabibullahmahmudncs/webapps/
- **Files**: https://www.pythonanywhere.com/user/mdhabibullahmahmudncs/files/
- **Consoles**: https://www.pythonanywhere.com/user/mdhabibullahmahmudncs/consoles/
- **Databases**: https://www.pythonanywhere.com/user/mdhabibullahmahmudncs/databases/

---

## 🆚 Free vs Paid Plans

### Free Tier Limitations
- 1 web app
- 512 MB disk space
- No custom domain
- No always-on tasks
- Your app sleeps after 3 months inactivity

### Paid Tier Benefits ($5/month)
- Custom domains
- More disk space
- Always-on tasks
- Faster CPUs
- More concurrent connections

---

## 🔧 Troubleshooting Checklist

- [ ] Virtual environment activated
- [ ] `.env` file exists with correct values
- [ ] `ALLOWED_HOSTS` includes PythonAnywhere domain
- [ ] Migrations run successfully
- [ ] Static files collected
- [ ] WSGI file configured correctly
- [ ] Static/Media paths set in Web tab
- [ ] Web app reloaded after changes
- [ ] Check error logs for details

---

## 📚 Additional Resources

- [PythonAnywhere Help](https://help.pythonanywhere.com/)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/)
- [PythonAnywhere Forums](https://www.pythonanywhere.com/forums/)

---

**PythonAnywhere Guide v1.0** | Last Updated: December 2025
