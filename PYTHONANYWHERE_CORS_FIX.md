# Fix CORS Issue on PythonAnywhere

## Problem
The frontend cannot fetch data from the backend because CORS headers are not properly configured.

## Solution

### Step 1: Edit .env file on PythonAnywhere

1. Go to **PythonAnywhere** → **Files** tab
2. Navigate to: `/home/habib29far/portfolio-svelte-django/backend/.env`
3. Create/edit the file with these contents:

```bash
# Django Settings
SECRET_KEY=change-this-to-a-random-secret-key-for-production
DEBUG=False
ALLOWED_HOSTS=habib29far.pythonanywhere.com

# CORS Settings
# Option 1: Allow all origins (TEMPORARY - for testing only)
CORS_ALLOW_ALL_ORIGINS=True

# Option 2: Allow specific origins (RECOMMENDED for production)
# CORS_ALLOWED_ORIGINS=https://your-frontend.vercel.app,https://your-frontend.netlify.app
```

### Step 2: Update settings.py (if needed)

Edit `/home/habib29far/portfolio-svelte-django/backend/portfolio_backend/settings.py`

Add this line after the CORS_ALLOWED_ORIGINS section (around line 142):

```python
# Allow all origins for development/testing
CORS_ALLOW_ALL_ORIGINS = config('CORS_ALLOW_ALL_ORIGINS', default=False, cast=bool)
```

### Step 3: Reload Web App

1. Go to **PythonAnywhere** → **Web** tab
2. Click the green **Reload** button for `habib29far.pythonanywhere.com`

### Step 4: Test CORS

Run this command to verify CORS headers are now present:

```bash
curl -v https://habib29far.pythonanywhere.com/api/hero/ 2>&1 | grep -i "access-control"
```

You should see:
```
< access-control-allow-origin: *
```

### Step 5: Update Frontend Environment

Make sure your frontend `.env` or `.env.production` has:

```bash
PUBLIC_API_URL=https://habib29far.pythonanywhere.com/api
```

### Step 6: Deploy Frontend

Once CORS is working:

1. Deploy to Vercel/Netlify
2. Get your frontend URL (e.g., `https://yoursite.vercel.app`)
3. Update PythonAnywhere `.env` to use specific origins:

```bash
CORS_ALLOW_ALL_ORIGINS=False
CORS_ALLOWED_ORIGINS=https://yoursite.vercel.app,https://www.yoursite.vercel.app
```

4. Reload the web app again

## Security Note

⚠️ **IMPORTANT**: `CORS_ALLOW_ALL_ORIGINS=True` should only be used for testing. Once your frontend is deployed, switch to `CORS_ALLOWED_ORIGINS` with specific domains for security.
