# Frontend Deployment Guide - SvelteKit Portfolio

Deploy your SvelteKit frontend to Vercel, Netlify, or Cloudflare Pages.

---

## 🎯 Deployment Architecture

```
Frontend (SvelteKit)          Backend (Django)
├─ Vercel/Netlify      →      ├─ PythonAnywhere
├─ your-site.vercel.app       ├─ mdhabibullahmahmudncs.pythonanywhere.com
└─ Serves UI/Pages            └─ Serves API endpoints
```

---

## 🚀 Option 1: Vercel (Recommended)

### Why Vercel?
- **Built for SvelteKit** - Zero config deployment
- **Free tier** with generous limits
- **Global CDN** - Fast worldwide
- **Auto HTTPS** - Free SSL certificates
- **GitHub integration** - Auto-deploy on push

### Step 1: Install Vercel CLI (Optional)

```bash
npm install -g vercel
```

### Step 2: Update Environment Variables

Edit `frontend/.env`:
```env
PUBLIC_API_URL=https://mdhabibullahmahmudncs.pythonanywhere.com/api
```

### Step 3: Deploy via GitHub (Easiest)

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git push origin main
   ```

2. **Connect to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Sign in with GitHub
   - Click **"Import Project"**
   - Select your repository
   - Choose `frontend` as root directory
   - Click **"Deploy"**

3. **Configure Environment**:
   - Project Settings → Environment Variables
   - Add: `PUBLIC_API_URL=https://mdhabibullahmahmudncs.pythonanywhere.com/api`
   - Redeploy

### Step 4: Deploy via CLI

```bash
cd frontend
vercel

# Follow prompts:
# - Link to existing project? No
# - Project name: portfolio-svelte
# - Directory: ./
# - Override settings? No

# Deploy to production
vercel --prod
```

### Vercel Configuration

Your `vercel.json` already exists:
```json
{
  "framework": "sveltekit",
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install"
}
```

---

## 🌐 Option 2: Netlify

### Step 1: Create netlify.toml

```toml
[build]
  command = "npm run build"
  publish = "build"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[build.environment]
  NODE_VERSION = "18"
```

### Step 2: Deploy via GitHub

1. Push code to GitHub
2. Go to [netlify.com](https://netlify.com)
3. Click **"Add new site"** → **"Import from Git"**
4. Select your repository
5. Configure:
   - **Base directory**: `frontend`
   - **Build command**: `npm run build`
   - **Publish directory**: `frontend/build`
6. Add environment variable:
   - `PUBLIC_API_URL=https://mdhabibullahmahmudncs.pythonanywhere.com/api`
7. Click **"Deploy"**

### Step 3: Deploy via CLI

```bash
# Install Netlify CLI
npm install -g netlify-cli

cd frontend

# Login
netlify login

# Deploy
netlify init
netlify deploy --prod
```

---

## ☁️ Option 3: Cloudflare Pages

### Step 1: Deploy via GitHub

1. Go to [pages.cloudflare.com](https://pages.cloudflare.com)
2. Click **"Create a project"**
3. Connect GitHub repository
4. Configure:
   - **Framework preset**: SvelteKit
   - **Build command**: `npm run build`
   - **Build output**: `build`
   - **Root directory**: `frontend`
5. Environment variables:
   - `PUBLIC_API_URL=https://mdhabibullahmahmudncs.pythonanywhere.com/api`
6. Click **"Save and Deploy"**

---

## 🔧 Update Backend CORS Settings

After deploying frontend, update your Django backend CORS settings:

**On PythonAnywhere**, edit `.env`:
```env
CORS_ALLOWED_ORIGINS=https://your-site.vercel.app,https://your-domain.com
```

Or in `settings.py`:
```python
CORS_ALLOWED_ORIGINS = [
    'https://your-site.vercel.app',
    'https://your-domain.com',
    'http://localhost:5173',  # For local development
]
```

**Reload PythonAnywhere web app** after changes!

---

## 🌍 Custom Domain

### Vercel Custom Domain

1. Project Settings → Domains
2. Add your domain: `www.yourdomain.com`
3. Update DNS records (provided by Vercel)
4. Wait for DNS propagation (~24 hours max)

### Netlify Custom Domain

1. Site Settings → Domain Management
2. Add custom domain
3. Update DNS or use Netlify DNS
4. SSL automatically configured

---

## 🔄 Continuous Deployment

All platforms support auto-deployment:

**Vercel/Netlify/Cloudflare**:
- Push to `main` branch → Auto-deploy to production
- Push to other branches → Create preview deployments
- Pull requests → Generate preview URLs

Configure in repository settings:
```bash
# .github/workflows/deploy.yml (optional)
name: Deploy Frontend

on:
  push:
    branches: [main]
    paths:
      - 'frontend/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          working-directory: ./frontend
```

---

## 📊 Comparison

| Platform | Free Tier | Build Time | CDN | Custom Domain | Best For |
|----------|-----------|------------|-----|---------------|----------|
| **Vercel** | ✅ Generous | ⚡ Fast | 🌍 Global | ✅ Free | SvelteKit |
| **Netlify** | ✅ Good | ⚡ Fast | 🌍 Global | ✅ Free | All frameworks |
| **Cloudflare** | ✅ Unlimited | ⚡ Fastest | 🌍 200+ cities | ✅ Free | Performance |

**Recommendation**: Use **Vercel** for SvelteKit - it's built by the same team!

---

## 🐛 Troubleshooting

### Build Fails

```bash
# Check Node version
node --version  # Should be 18+ or 20+

# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Test build locally
npm run build
```

### API Calls Fail

**Check CORS settings** on Django backend:
```python
CORS_ALLOWED_ORIGINS = [
    'https://your-vercel-app.vercel.app',
]
```

**Check environment variable**:
```bash
# In Vercel/Netlify dashboard
PUBLIC_API_URL=https://mdhabibullahmahmudncs.pythonanywhere.com/api
```

### Environment Variables Not Working

SvelteKit requires `PUBLIC_` prefix for client-side variables:
```env
PUBLIC_API_URL=...  # ✅ Correct
API_URL=...         # ❌ Won't work in browser
```

---

## 🎯 Complete Deployment Checklist

### Backend (PythonAnywhere) ✅
- [x] Django deployed
- [x] Database configured
- [x] Static files collected
- [x] CORS configured
- [ ] Update CORS with frontend domain after deployment

### Frontend (Vercel/Netlify)
- [ ] Push code to GitHub
- [ ] Connect repository to Vercel/Netlify
- [ ] Set `PUBLIC_API_URL` environment variable
- [ ] Deploy and test
- [ ] Update backend CORS with deployed URL
- [ ] Configure custom domain (optional)
- [ ] Test all API endpoints

---

## 💡 Local Development

Keep both servers running locally:

```bash
# Terminal 1: Backend
cd backend
python manage.py runserver

# Terminal 2: Frontend
cd frontend
npm run dev
```

Update `frontend/.env` for local development:
```env
PUBLIC_API_URL=http://localhost:8000/api
```

---

## 🔐 Security Notes

1. **Never commit `.env` files** - use `.env.example` as template
2. **Use HTTPS** for API calls in production
3. **Configure CORS** properly - don't use `CORS_ALLOW_ALL_ORIGINS = True`
4. **Set secure headers** in Django settings
5. **Use environment variables** for all sensitive data

---

**Frontend Deployment Guide v1.0** | Last Updated: December 2025
