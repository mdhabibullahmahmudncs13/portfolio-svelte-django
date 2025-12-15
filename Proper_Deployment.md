# Complete Deployment Guide - Portfolio Project

**Deploy your SvelteKit + Django portfolio to production in under 30 minutes**

This guide covers deploying:
- **Backend (Django)** → PythonAnywhere
- **Frontend (SvelteKit)** → Vercel

---

## 📋 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Part 1: Deploy Backend to PythonAnywhere](#part-1-deploy-backend-to-pythonanywhere)
4. [Part 2: Deploy Frontend to Vercel](#part-2-deploy-frontend-to-vercel)
5. [Part 3: Connect Frontend & Backend](#part-3-connect-frontend--backend)
6. [Testing Your Deployment](#testing-your-deployment)
7. [Updating Your Deployment](#updating-your-deployment)
8. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  User Browser                                       │
│                                                     │
└────────────┬────────────────────────────────────────┘
             │
             ├──────────────────────────────────────┐
             │                                      │
             ▼                                      ▼
┌────────────────────────┐           ┌─────────────────────────┐
│  Frontend (SvelteKit)  │           │  Backend (Django)       │
│  Vercel                │  ───────► │  PythonAnywhere         │
│  your-site.vercel.app  │   API     │  username.pythonanywhere│
│                        │  Calls    │  .com                   │
│  - Serves UI           │           │  - REST API             │
│  - Static files        │           │  - Database             │
│  - Global CDN          │           │  - Media files          │
└────────────────────────┘           └─────────────────────────┘
```

**Why split deployment?**
- PythonAnywhere: Python-only, perfect for Django
- Vercel: Built for SvelteKit, global CDN, instant deployments
- Industry standard: Separate frontend/backend deployments

---

## Prerequisites

### Accounts Needed
- [x] GitHub account (for code hosting)
- [x] PythonAnywhere account (free tier works)
- [x] Vercel account (free tier works)

### Tools Required
```bash
# Check if you have these installed
git --version
python3 --version
node --version
npm --version
```

### Repository Setup
```bash
# Make sure your code is on GitHub
git remote -v  # Should show your GitHub repo
```

---

## Part 1: Deploy Backend to PythonAnywhere

### Step 1.1: Create PythonAnywhere Account

1. Go to [www.pythonanywhere.com](https://www.pythonanywhere.com)
2. Click **"Start running Python online in less than a minute"**
3. Create free account (no credit card required)
4. Verify your email

### Step 1.2: Clone Your Repository

1. Open a **Bash console** in PythonAnywhere dashboard
2. Clone your repository:

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/portfolio-svelte-django.git
cd portfolio-svelte-django/backend
```

**Replace** `YOUR_USERNAME` with your actual GitHub username.

### Step 1.3: Create Virtual Environment

```bash
# Create virtual environment with Python 3.10
mkvirtualenv --python=/usr/bin/python3.10 portfolio-env

# You should see (portfolio-env) in your prompt now

# Install dependencies
pip install -r requirements.txt
```

**Wait 2-3 minutes** for installation to complete.

### Step 1.4: Configure Environment Variables

```bash
# Create .env file
nano .env
```

**Copy and paste** this (update the SECRET_KEY):

```env
SECRET_KEY=your-secret-key-change-this-to-something-random
DEBUG=False
ALLOWED_HOSTS=YOUR_USERNAME.pythonanywhere.com
CORS_ALLOWED_ORIGINS=http://localhost:5173
```

**Generate a SECRET_KEY**:
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

**Save the file**: Press `Ctrl+X`, then `Y`, then `Enter`

**Important**: Replace `YOUR_USERNAME` with your PythonAnywhere username (e.g., `mdhabibullahmahmudncs`)

### Step 1.5: Setup Database

```bash
# Run migrations
python manage.py migrate

# Create superuser (admin account)
python manage.py createsuperuser
# Enter username: admin
# Enter email: your-email@example.com
# Enter password: (choose a strong password)

# Collect static files
python manage.py collectstatic --noinput
```

### Step 1.6: Configure Web App

1. Go to **Web** tab in PythonAnywhere dashboard
2. Click **"Add a new web app"**
3. Click **"Next"** (for your domain)
4. Select **"Manual configuration"**
5. Choose **Python 3.10**
6. Click **"Next"**

### Step 1.7: Configure WSGI File

1. In the **Web** tab, find the **Code** section
2. Click on the **WSGI configuration file** link (something like `/var/www/username_pythonanywhere_com_wsgi.py`)
3. **Delete everything** in the file
4. **Replace** with this code:

```python
import os
import sys
from pathlib import Path

# Add your project directory to sys.path
path = '/home/YOUR_USERNAME/portfolio-svelte-django/backend'
if path not in sys.path:
    sys.path.insert(0, path)

# Set Django settings module
os.environ['DJANGO_SETTINGS_MODULE'] = 'portfolio_backend.settings'

# Load environment variables from .env file
from pathlib import Path
from decouple import Config, RepositoryEnv

env_path = Path('/home/YOUR_USERNAME/portfolio-svelte-django/backend/.env')
if env_path.exists():
    config = Config(RepositoryEnv(env_path))

# Initialize Django WSGI application
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

**Replace** `YOUR_USERNAME` with your PythonAnywhere username (appears 2 times).

**Save**: Click the green **"Save"** button at the top.

### Step 1.8: Configure Virtual Environment Path

1. Still in the **Web** tab, find the **Virtualenv** section
2. Enter the path:
   ```
   /home/YOUR_USERNAME/.virtualenvs/portfolio-env
   ```
   **Replace** `YOUR_USERNAME` with your username

### Step 1.9: Configure Static Files

1. In the **Web** tab, find the **Static files** section
2. Click **"Enter path"** and add:

| URL | Directory |
|-----|-----------|
| `/static/` | `/home/YOUR_USERNAME/portfolio-svelte-django/backend/staticfiles/` |
| `/media/` | `/home/YOUR_USERNAME/portfolio-svelte-django/backend/media/` |

**Replace** `YOUR_USERNAME` in both paths.

### Step 1.10: Reload Web App

1. Scroll to the top of the **Web** tab
2. Click the big green **"Reload"** button
3. Wait 10 seconds

### Step 1.11: Test Backend Deployment

Open these URLs in your browser:

✅ **API Root**: `https://YOUR_USERNAME.pythonanywhere.com/api/`  
✅ **Admin Panel**: `https://YOUR_USERNAME.pythonanywhere.com/admin/`

You should see the Django REST Framework browsable API and be able to login to admin!

**Note your API URL** - you'll need it for frontend deployment:
```
https://YOUR_USERNAME.pythonanywhere.com/api
```

---

## Part 2: Deploy Frontend to Vercel

### Step 2.1: Create Vercel Account

1. Go to [vercel.com](https://vercel.com)
2. Click **"Sign Up"**
3. Choose **"Continue with GitHub"**
4. Authorize Vercel to access your repositories

### Step 2.2: Prepare Frontend for Deployment

**On your local machine**, update the production environment file:

```bash
cd frontend
nano .env.production
```

**Add this line** (replace with your PythonAnywhere URL):
```env
PUBLIC_API_URL=https://YOUR_USERNAME.pythonanywhere.com/api
```

**Save and commit**:
```bash
git add .env.production
git commit -m "Add production environment config"
git push origin main
```

### Step 2.3: Import Project to Vercel

1. In Vercel dashboard, click **"Add New..."** → **"Project"**
2. Click **"Import"** next to your repository
3. Configure project:
   - **Framework Preset**: SvelteKit (auto-detected)
   - **Root Directory**: Click "Edit" and enter `frontend`
   - **Build Command**: `npm run build` (default)
   - **Output Directory**: `build` (default)

4. **Environment Variables**: Click "Add Environment Variable"
   ```
   Name: PUBLIC_API_URL
   Value: https://YOUR_USERNAME.pythonanywhere.com/api
   ```

5. Click **"Deploy"**

### Step 2.4: Wait for Build

- Vercel will build your app (takes 1-3 minutes)
- Watch the build logs in real-time
- When complete, you'll see "Congratulations!" 🎉

### Step 2.5: Get Your Frontend URL

After deployment completes, you'll see your live URL:
```
https://your-project-name-abc123.vercel.app
```

**Note this URL** - you'll need it to configure CORS!

---

## Part 3: Connect Frontend & Backend

### Step 3.1: Update Backend CORS Settings

Your frontend needs permission to call your backend API.

**On PythonAnywhere**, open a Bash console:

```bash
cd ~/portfolio-svelte-django/backend
nano .env
```

**Update** the `CORS_ALLOWED_ORIGINS` line:
```env
CORS_ALLOWED_ORIGINS=https://your-project-name-abc123.vercel.app,http://localhost:5173
```

**Add your actual Vercel URL** (from Step 2.5).

**Save**: `Ctrl+X`, `Y`, `Enter`

### Step 3.2: Reload PythonAnywhere Web App

1. Go to PythonAnywhere **Web** tab
2. Click the green **"Reload"** button
3. Wait 10 seconds

### Step 3.3: Test the Connection

1. Open your Vercel frontend URL
2. The page should load with all your portfolio data
3. Try the contact form - it should submit successfully

---

## Testing Your Deployment

### ✅ Backend Checklist

Test these URLs (replace `YOUR_USERNAME`):

- [ ] **API Root**: `https://YOUR_USERNAME.pythonanywhere.com/api/`
  - Should show: Django REST Framework browsable API
  
- [ ] **Admin Panel**: `https://YOUR_USERNAME.pythonanywhere.com/admin/`
  - Should show: Django admin login
  
- [ ] **Skills Endpoint**: `https://YOUR_USERNAME.pythonanywhere.com/api/skills/`
  - Should show: List of skills (or empty array)
  
- [ ] **Hero Endpoint**: `https://YOUR_USERNAME.pythonanywhere.com/api/hero/`
  - Should show: Hero data (or null)

### ✅ Frontend Checklist

Test your Vercel URL:

- [ ] **Homepage loads**: Should see your portfolio
- [ ] **Skills section**: Should display your skills
- [ ] **Projects section**: Should show projects
- [ ] **Contact form**: Should submit successfully
- [ ] **Images load**: Profile image, skill icons visible
- [ ] **Responsive**: Test on mobile/tablet

### ✅ Connection Checklist

- [ ] **Open browser console** (F12) on your Vercel site
- [ ] **No CORS errors**: Should not see "blocked by CORS policy"
- [ ] **API calls work**: Network tab shows successful API requests
- [ ] **Data displays**: Content from Django appears on frontend

---

## Updating Your Deployment

### Update Backend (PythonAnywhere)

```bash
# SSH to PythonAnywhere console
cd ~/portfolio-svelte-django/backend

# Activate virtual environment
workon portfolio-env

# Pull latest changes
git pull origin main

# Update dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput
```

**Then reload** web app in the Web tab!

**Or use the automated script**:
```bash
cd ~/portfolio-svelte-django/backend
./deploy/pythonanywhere_update.sh
```

### Update Frontend (Vercel)

**Automatic deployment** - just push to GitHub:

```bash
git add .
git commit -m "Update frontend"
git push origin main
```

Vercel automatically rebuilds and deploys! Check deployment status in Vercel dashboard.

**Manual deployment** (if needed):
```bash
cd frontend
vercel --prod
```

---

## Troubleshooting

### Backend Issues

#### ❌ "ImportError: No module named ..."

**Solution**:
```bash
workon portfolio-env
pip install -r requirements.txt
```

#### ❌ "DisallowedHost" Error

**Solution**: Update `.env`:
```env
ALLOWED_HOSTS=YOUR_USERNAME.pythonanywhere.com
```
Then reload web app.

#### ❌ Static Files Not Loading

**Solution**:
```bash
cd ~/portfolio-svelte-django/backend
workon portfolio-env
python manage.py collectstatic --noinput
```

Check static files paths in Web tab.

#### ❌ Database Errors

**Solution**:
```bash
cd ~/portfolio-svelte-django/backend
workon portfolio-env
python manage.py migrate
```

#### ❌ Can't See Error Logs

**Check logs**:
- Web tab → "Log files" section
- Click "Server log" or "Error log"

### Frontend Issues

#### ❌ Build Fails on Vercel

**Solution 1**: Check build logs for specific error

**Solution 2**: Test build locally:
```bash
cd frontend
npm install
npm run build
```

**Solution 3**: Check Node.js version:
- Vercel uses Node 18+ by default
- Your project requires Node 18+

#### ❌ "PUBLIC_API_URL is not defined"

**Solution**: Add environment variable in Vercel:
1. Project Settings → Environment Variables
2. Add: `PUBLIC_API_URL=https://YOUR_USERNAME.pythonanywhere.com/api`
3. Redeploy

#### ❌ API Calls Return CORS Error

**Solution**: Update backend `.env`:
```env
CORS_ALLOWED_ORIGINS=https://your-vercel-url.vercel.app
```

Make sure:
- Use `https://` not `http://`
- No trailing slash
- Exact URL match
- Reload PythonAnywhere web app after changes

#### ❌ Images/Media Not Loading

**Solution**: Check `getMediaUrl()` function in `lib/api.ts`:
```typescript
export function getMediaUrl(path: string | null): string {
  if (!path) return '';
  if (path.startsWith('http')) return path;
  const baseUrl = API_BASE.replace('/api/', '');
  return `${baseUrl}${path}`;
}
```

### Connection Issues

#### ❌ Frontend Shows No Data

**Check**:
1. Open browser console (F12)
2. Go to Network tab
3. Reload page
4. Check API requests:
   - Status should be 200
   - Response should have data

**If 404**: API URL wrong in environment variables

**If CORS error**: Update backend CORS settings

**If empty data**: Add content in Django admin panel

---

## Custom Domain Setup (Optional)

### Add Custom Domain to Vercel

1. Vercel Dashboard → Your Project
2. Settings → Domains
3. Add your domain: `www.yourdomain.com`
4. Follow DNS instructions
5. Wait for DNS propagation (up to 24 hours)

### Update Backend CORS for Custom Domain

```bash
# On PythonAnywhere
cd ~/portfolio-svelte-django/backend
nano .env
```

Add your domain:
```env
CORS_ALLOWED_ORIGINS=https://www.yourdomain.com,https://your-project.vercel.app
```

Reload web app!

---

## Performance Tips

### Backend Optimization

1. **Use MySQL instead of SQLite** (PythonAnywhere provides free MySQL)
2. **Enable caching** in Django settings
3. **Optimize database queries** (use select_related/prefetch_related)
4. **Compress images** before uploading

### Frontend Optimization

1. **Optimize images** - use WebP format
2. **Lazy load images** - only load when visible
3. **Code splitting** - SvelteKit does this automatically
4. **Reduce bundle size** - remove unused dependencies

---

## Security Checklist

- [x] `DEBUG = False` in production
- [x] Strong `SECRET_KEY` (randomly generated)
- [x] HTTPS enabled (automatic on both platforms)
- [x] CORS properly configured (not `CORS_ALLOW_ALL_ORIGINS`)
- [x] Strong admin password
- [x] `.env` file not committed to git
- [x] `ALLOWED_HOSTS` properly set
- [x] Regular updates to dependencies

---

## Quick Reference

### Important URLs

**Your URLs** (replace placeholders):
- Backend API: `https://YOUR_USERNAME.pythonanywhere.com/api/`
- Backend Admin: `https://YOUR_USERNAME.pythonanywhere.com/admin/`
- Frontend: `https://your-project.vercel.app`

**Dashboards**:
- PythonAnywhere: https://www.pythonanywhere.com/user/YOUR_USERNAME/
- Vercel: https://vercel.com/dashboard

### Essential Commands

**Backend (PythonAnywhere)**:
```bash
workon portfolio-env                    # Activate environment
cd ~/portfolio-svelte-django/backend    # Go to project
git pull                                # Update code
python manage.py migrate                # Run migrations
python manage.py collectstatic --noinput # Collect static
```

**Frontend (Local)**:
```bash
cd frontend
git pull                    # Update code
npm install                 # Update dependencies
npm run dev                 # Test locally
git push                    # Deploy (triggers Vercel)
```

---

## Support

### PythonAnywhere Help
- Forums: https://www.pythonanywhere.com/forums/
- Help pages: https://help.pythonanywhere.com/

### Vercel Help
- Documentation: https://vercel.com/docs
- Support: https://vercel.com/support

### Project Issues
If you encounter issues with this project, check:
1. Browser console for frontend errors
2. PythonAnywhere error logs for backend issues
3. Vercel build logs for deployment issues

---

## Deployment Summary

```
✅ Backend (Django) → PythonAnywhere
   - Free tier: 512MB, 1 web app
   - URL: https://YOUR_USERNAME.pythonanywhere.com
   - Database: SQLite (or upgrade to MySQL)
   - HTTPS: Included
   
✅ Frontend (SvelteKit) → Vercel
   - Free tier: Unlimited bandwidth
   - URL: https://your-project.vercel.app
   - CDN: Global edge network
   - HTTPS: Included
   - Auto-deploy: On git push
```

**Total Cost**: $0/month (both free tiers)

**Total Time**: ~20-30 minutes for first deployment

---

**Congratulations! Your portfolio is now live! 🎉**

Share your links:
- Frontend: `https://your-project.vercel.app`
- API: `https://YOUR_USERNAME.pythonanywhere.com/api/`

---

**Deployment Guide v1.0** | Last Updated: December 2025
