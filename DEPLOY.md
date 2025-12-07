# Deployment Guide: Portfolio Website

This guide explains how to deploy your SvelteKit + Django portfolio application with the backend on PythonAnywhere and the frontend on Vercel.

---

## Table of Contents
1. [Backend Deployment (PythonAnywhere)](#backend-deployment-pythonanywhere)
2. [Frontend Deployment (Vercel)](#frontend-deployment-vercel)
3. [Post-Deployment Configuration](#post-deployment-configuration)
4. [Troubleshooting](#troubleshooting)

---

## Backend Deployment (PythonAnywhere)

### Prerequisites
- PythonAnywhere account (Free or Paid tier)
- Your Django project pushed to GitHub

### Step 1: Create PythonAnywhere Account
1. Go to [PythonAnywhere.com](https://www.pythonanywhere.com/)
2. Sign up for a free account or choose a paid plan
3. Verify your email address

### Step 2: Upload Your Code
1. Open a **Bash console** from your PythonAnywhere dashboard
2. Clone your repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/portfolio-svelte-django.git
   cd portfolio-svelte-django/backend
   ```

### Step 3: Set Up Virtual Environment
```bash
# Create virtual environment
mkvirtualenv --python=/usr/bin/python3.10 portfolio-env

# Activate it (should auto-activate)
workon portfolio-env

# Install dependencies
pip install -r requirements.txt
```

### Step 4: Configure Django Settings
1. Edit `portfolio_backend/settings.py`:
   ```bash
   nano portfolio_backend/settings.py
   ```

2. Update these settings:
   ```python
   # SECURITY WARNING: keep the secret key used in production secret!
   SECRET_KEY = 'your-production-secret-key-here'  # Generate a new one!
   
   DEBUG = False
   
   ALLOWED_HOSTS = ['YOUR_USERNAME.pythonanywhere.com']
   
   # CORS settings
   CORS_ALLOWED_ORIGINS = [
       'https://your-vercel-app.vercel.app',  # Add your Vercel URL later
   ]
   
   # Database - use MySQL on PythonAnywhere
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': 'YOUR_USERNAME$portfolio',
           'USER': 'YOUR_USERNAME',
           'PASSWORD': 'your_mysql_password',
           'HOST': 'YOUR_USERNAME.mysql.pythonanywhere-services.com',
       }
   }
   
   # Static files
   STATIC_URL = '/static/'
   STATIC_ROOT = '/home/YOUR_USERNAME/portfolio-svelte-django/backend/static'
   
   # Media files
   MEDIA_URL = '/media/'
   MEDIA_ROOT = '/home/YOUR_USERNAME/portfolio-svelte-django/backend/media'
   ```

### Step 5: Set Up MySQL Database
1. Go to **Databases** tab in PythonAnywhere dashboard
2. Set a MySQL password if you haven't already
3. Create a new database named `YOUR_USERNAME$portfolio`
4. Note down the connection details

### Step 6: Run Migrations
```bash
cd /home/YOUR_USERNAME/portfolio-svelte-django/backend
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser  # Create admin account
```

### Step 7: Configure Web App
1. Go to **Web** tab in PythonAnywhere dashboard
2. Click **Add a new web app**
3. Choose **Manual configuration**
4. Select **Python 3.10**

5. Configure WSGI file:
   - Click on the WSGI configuration file link
   - Replace content with:
   ```python
   import os
   import sys
   
   # Add your project directory to the sys.path
   path = '/home/YOUR_USERNAME/portfolio-svelte-django/backend'
   if path not in sys.path:
       sys.path.insert(0, path)
   
   # Set environment variables
   os.environ['DJANGO_SETTINGS_MODULE'] = 'portfolio_backend.settings'
   
   # Activate virtual environment
   from django.core.wsgi import get_wsgi_application
   application = get_wsgi_application()
   ```

6. Configure Virtual Environment:
   - In the **Virtualenv** section, enter:
     ```
     /home/YOUR_USERNAME/.virtualenvs/portfolio-env
     ```

7. Configure Static Files:
   - URL: `/static/`
   - Directory: `/home/YOUR_USERNAME/portfolio-svelte-django/backend/static`
   
8. Configure Media Files:
   - URL: `/media/`
   - Directory: `/home/YOUR_USERNAME/portfolio-svelte-django/backend/media`

### Step 8: Reload Web App
1. Click the green **Reload** button
2. Visit `https://YOUR_USERNAME.pythonanywhere.com` to test
3. Check error logs if there are issues

---

## Frontend Deployment (Vercel)

### Prerequisites
- Vercel account (free)
- Your code pushed to GitHub

### Step 1: Create Vercel Account
1. Go to [Vercel.com](https://vercel.com/)
2. Sign up with GitHub
3. Authorize Vercel to access your repositories

### Step 2: Prepare Frontend Code
1. Update API URL in `frontend/src/lib/api.ts`:
   ```typescript
   const API_BASE_URL = import.meta.env.VITE_API_URL || 'https://YOUR_USERNAME.pythonanywhere.com/api';
   ```

2. Create `.env.production` file in frontend directory:
   ```env
   VITE_API_URL=https://YOUR_USERNAME.pythonanywhere.com/api
   ```

3. Commit and push changes:
   ```bash
   git add .
   git commit -m "Update API URL for production"
   git push origin main
   ```

### Step 3: Deploy to Vercel
1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Click **Add New Project**
3. Import your GitHub repository
4. Configure project:
   - **Framework Preset:** SvelteKit
   - **Root Directory:** `frontend`
   - **Build Command:** `npm run build` (auto-detected)
   - **Output Directory:** `.svelte-kit` (auto-detected)

5. Add Environment Variables:
   - Click **Environment Variables**
   - Add: `VITE_API_URL` = `https://YOUR_USERNAME.pythonanywhere.com/api`

6. Click **Deploy**

### Step 4: Wait for Deployment
- Vercel will build and deploy your app
- You'll get a URL like `https://your-project.vercel.app`
- Deployment typically takes 1-3 minutes

---

## Post-Deployment Configuration

### Step 1: Update CORS on Backend
1. SSH into PythonAnywhere or use the console
2. Edit `settings.py`:
   ```python
   CORS_ALLOWED_ORIGINS = [
       'https://your-project.vercel.app',  # Your actual Vercel URL
       'https://your-custom-domain.com',   # If you have a custom domain
   ]
   ```
3. Reload your PythonAnywhere web app

### Step 2: Upload Media Files
1. Use PythonAnywhere's **Files** tab or SFTP
2. Upload your `media/` folder content to:
   ```
   /home/YOUR_USERNAME/portfolio-svelte-django/backend/media/
   ```

### Step 3: Populate Database
1. Access Django admin at `https://YOUR_USERNAME.pythonanywhere.com/admin`
2. Add your portfolio data:
   - Hero information
   - Skills
   - Projects
   - Experience
   - Certifications
   - Contact info

### Step 4: Test Everything
1. Visit your Vercel URL
2. Test all functionality:
   - Hero section loads
   - Skills display with scrolling animation
   - Projects section
   - Certifications with images
   - Contact form submission
   - Admin panel access

### Step 5: Custom Domain (Optional)

#### For Vercel (Frontend):
1. Go to your project in Vercel
2. Click **Settings** → **Domains**
3. Add your custom domain
4. Update DNS records as instructed by Vercel

#### For PythonAnywhere (Backend API):
1. Upgrade to paid plan (required for custom domains)
2. Go to **Web** tab
3. Add custom domain in the configuration section
4. Update DNS records to point to PythonAnywhere

---

## Environment Variables Summary

### Backend (PythonAnywhere)
Set these in your `settings.py` or use environment variables:
```python
SECRET_KEY='your-secret-key'
DEBUG=False
ALLOWED_HOSTS=['YOUR_USERNAME.pythonanywhere.com']
DATABASE_PASSWORD='your_mysql_password'
```

### Frontend (Vercel)
Set in Vercel dashboard under **Environment Variables**:
```
VITE_API_URL=https://YOUR_USERNAME.pythonanywhere.com/api
```

---

## Updating Your Deployment

### Backend Updates
```bash
# SSH into PythonAnywhere console
cd /home/YOUR_USERNAME/portfolio-svelte-django/backend
git pull origin main
workon portfolio-env
pip install -r requirements.txt  # If dependencies changed
python manage.py migrate  # If models changed
python manage.py collectstatic --noinput  # If static files changed

# Then reload web app from Web tab
```

### Frontend Updates
```bash
# Just push to GitHub - Vercel auto-deploys!
git add .
git commit -m "Update frontend"
git push origin main
```

Or manually redeploy from Vercel dashboard:
1. Go to **Deployments** tab
2. Click **...** on latest deployment
3. Click **Redeploy**

---

## Troubleshooting

### Backend Issues

#### 500 Internal Server Error
1. Check error logs in PythonAnywhere **Web** tab → **Log files**
2. Common issues:
   - Missing dependencies: `pip install -r requirements.txt`
   - Database not migrated: `python manage.py migrate`
   - Wrong WSGI configuration
   - Virtual environment not activated

#### Static/Media Files Not Loading
1. Verify paths in **Web** tab configuration
2. Run `python manage.py collectstatic --noinput`
3. Check file permissions: `chmod -R 755 media/ static/`

#### Database Connection Errors
1. Verify database credentials in `settings.py`
2. Check MySQL is running
3. Ensure database exists: `YOUR_USERNAME$portfolio`

### Frontend Issues

#### API Calls Failing
1. Check CORS settings on backend
2. Verify `VITE_API_URL` in Vercel environment variables
3. Check browser console for errors
4. Test API directly: `https://YOUR_USERNAME.pythonanywhere.com/api/hero/`

#### Build Failures on Vercel
1. Check build logs in Vercel dashboard
2. Verify `package.json` has all dependencies
3. Ensure `npm run build` works locally
4. Check Node.js version compatibility

#### Images Not Loading
1. Verify media files uploaded to PythonAnywhere
2. Check media URL configuration in Django settings
3. Ensure CORS allows media files

---

## Security Checklist

- [ ] Generated new `SECRET_KEY` for production
- [ ] Set `DEBUG = False` in Django settings
- [ ] Configured `ALLOWED_HOSTS` properly
- [ ] Set up CORS with specific domains (not `*`)
- [ ] Using strong MySQL password
- [ ] Environment variables not exposed in code
- [ ] HTTPS enabled on both frontend and backend
- [ ] Admin panel has strong password
- [ ] Regular security updates: `pip install --upgrade django`

---

## Monitoring & Maintenance

### PythonAnywhere
- Check error logs regularly in **Web** tab
- Monitor CPU usage (free tier has limits)
- Set up daily backups of database
- Keep dependencies updated

### Vercel
- Monitor build times and failures
- Check analytics in dashboard
- Review function logs if using serverless functions
- Update dependencies regularly

---

## Cost Breakdown

### Free Tier Limitations

**PythonAnywhere Free:**
- 1 web app
- 512 MB storage
- No custom domain
- Limited CPU time
- HTTP only (no HTTPS for custom domains)

**Vercel Free:**
- Unlimited projects
- 100 GB bandwidth/month
- Automatic HTTPS
- Custom domains supported

### Recommended Upgrades
- **PythonAnywhere Hacker ($5/month):** Custom domain, more CPU, HTTPS
- **Vercel Pro ($20/month):** Team features, better analytics, priority support

---

## Backup Strategy

### Database Backup (PythonAnywhere)
```bash
# Run from console
mysqldump -u YOUR_USERNAME -p YOUR_USERNAME$portfolio > backup_$(date +%Y%m%d).sql
```

### Media Files Backup
```bash
# Download via SFTP or from Files tab
tar -czf media_backup.tar.gz media/
```

### Code Backup
- Already backed up in GitHub repository
- Create release tags for major versions

---

## Additional Resources

- [PythonAnywhere Django Tutorial](https://help.pythonanywhere.com/pages/DeployExistingDjangoProject/)
- [Vercel SvelteKit Deployment](https://vercel.com/docs/frameworks/sveltekit)
- [Django Production Checklist](https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/)
- [SvelteKit Deployment Docs](https://kit.svelte.dev/docs/adapter-vercel)

---

## Support

If you encounter issues:
1. Check error logs first
2. Review this deployment guide
3. Search PythonAnywhere forums
4. Check Vercel documentation
5. Review Django and SvelteKit docs

**Remember:** Always test changes locally before deploying to production!

---

*Last Updated: December 2025*
