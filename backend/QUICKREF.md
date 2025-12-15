# Django Portfolio Backend - Quick Reference

## 🚀 Quick Commands

### Setup
```bash
# Automated setup (Linux/Mac)
./create_django_project.sh

# Manual setup
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
```

### Development
```bash
# Run server
python manage.py runserver

# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Django shell
python manage.py shell

# Collect static files
python manage.py collectstatic
```

### Data Management
```bash
# Export all data
python manage.py dumpdata > backup.json

# Export specific model
python manage.py dumpdata api.Skill --indent 2 > skills.json

# Import data
python manage.py loaddata backup.json

# Flush database (careful!)
python manage.py flush
```

---

## 📋 API Endpoints Reference

### Public (No Auth Required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/hero/` | Get hero/about info |
| GET | `/api/skills/` | List all skills |
| GET | `/api/projects/` | List all projects |
| GET | `/api/projects/featured/` | Featured projects only |
| GET | `/api/experience/` | List work experience |
| GET | `/api/certifications/` | List certifications |
| GET | `/api/contact/` | Get contact info |
| GET | `/api/activities/` | List activities |
| GET | `/api/blog/` | List blog posts |
| POST | `/api/messages/` | Submit contact form |

### Admin (Auth Required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/token/` | Get JWT token |
| POST | `/api/token/refresh/` | Refresh token |
| POST | `/api/{resource}/` | Create resource |
| PUT | `/api/{resource}/{id}/` | Update resource |
| DELETE | `/api/{resource}/{id}/` | Delete resource |

---

## 🗄️ Models Quick Reference

### Hero
```python
name, tagline, description, media_type, image_url, video_url, resume_url
github_url, linkedin_url, twitter_url, hackerrank_url
```

### Skill
```python
name, category, icon, icon_image, order
# Categories: language, framework, tool, platform, other
```

### Project
```python
title, description, long_description, media_type, image_url, video_url
demo_url, github_url, technologies, category, featured, order
```

### Experience
```python
company, position, description, start_date, end_date, current
technologies, order
```

### Certification
```python
name, issuer, category, issue_date, expiry_date
credential_id, credential_url, image_url, order
# Categories: achievements, certificate, participation
```

### Contact
```python
email, phone, location, availability
```

### Message
```python
name, email, subject, message, read, created_at
```

### BlogPost
```python
title, slug, excerpt, content, image_url, tags, published
```

### ExtraCurricularActivity
```python
title, organization, role, description, start_date, end_date
current, image_url, achievements, order
```

---

## 🔧 Environment Variables

### Development (.env)
```env
SECRET_KEY=your-random-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://127.0.0.1:5173
```

### Production (.env)
```env
SECRET_KEY=<strong-secret-key>
DEBUG=False
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
DATABASE_URL=postgresql://user:pass@host:5432/dbname
```

---

## 🧪 Testing Endpoints

### cURL Examples
```bash
# Get skills
curl http://localhost:8000/api/skills/

# Get hero
curl http://localhost:8000/api/hero/

# Submit message
curl -X POST http://localhost:8000/api/messages/ \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@example.com","subject":"Hi","message":"Hello"}'

# Get JWT token
curl -X POST http://localhost:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"yourpass"}'

# Create skill (with auth)
curl -X POST http://localhost:8000/api/skills/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"name":"Python","category":"language","icon":"🐍","order":1}'
```

---

## 🐛 Common Issues & Fixes

### Port Already in Use
```bash
# Find process
lsof -i :8000
# Kill it
kill -9 <PID>
# Or use different port
python manage.py runserver 8080
```

### Migration Errors
```bash
# Reset migrations (dev only!)
python manage.py migrate --fake api zero
rm api/migrations/0*.py
python manage.py makemigrations
python manage.py migrate
```

### CORS Errors
```bash
# Check CORS_ALLOWED_ORIGINS in .env
# Ensure django-cors-headers is installed
pip install django-cors-headers
# Verify CorsMiddleware is first in MIDDLEWARE (settings.py)
```

### ImportError
```bash
# Activate venv
source venv/bin/activate
# Reinstall
pip install -r requirements.txt
```

### Static/Media Files Not Loading
```bash
# Check settings.py
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Collect static
python manage.py collectstatic

# In urls.py (development only)
from django.conf.urls.static import static
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

---

## 📁 Project Files

### Essential Files
- `manage.py` - Django management script
- `requirements.txt` - Python dependencies
- `.env` - Environment variables (don't commit!)
- `db.sqlite3` - SQLite database (dev)

### Configuration
- `portfolio_backend/settings.py` - Django settings
- `portfolio_backend/urls.py` - Main URL config
- `portfolio_backend/wsgi.py` - WSGI config

### API Application
- `api/models.py` - Database models
- `api/serializers.py` - DRF serializers
- `api/views.py` - API views
- `api/urls.py` - API routes
- `api/admin.py` - Admin configuration

---

## 🎯 Workflows

### Adding New Model Field
```bash
1. Edit api/models.py (add field)
2. python manage.py makemigrations
3. python manage.py migrate
4. Update api/admin.py (optional)
5. Update api/serializers.py (if needed)
```

### Creating New Endpoint
```python
# In api/views.py
@action(detail=False, methods=['get'])
def custom_endpoint(self, request):
    # Your logic
    return Response(data)
```

### Adding Custom Permission
```python
# In api/views.py
class CustomPermission(permissions.BasePermission):
    def has_permission(self, request, view):
        # Your logic
        return True
```

---

## 🔐 Security Checklist

- [ ] `DEBUG = False` in production
- [ ] Strong `SECRET_KEY` generated
- [ ] `ALLOWED_HOSTS` configured
- [ ] CORS origins restricted
- [ ] HTTPS enabled
- [ ] Database credentials secure
- [ ] Media files permissions set
- [ ] Admin password strong
- [ ] Regular backups enabled
- [ ] Security updates applied

---

## 📊 Admin Panel Quick Start

1. Access: `http://localhost:8000/admin/`
2. Login with superuser credentials
3. Add data through forms
4. Models are organized by app
5. Use bulk actions for efficiency

### Admin URLs
- Hero: `/admin/api/hero/`
- Skills: `/admin/api/skill/`
- Projects: `/admin/api/project/`
- Certifications: `/admin/api/certification/`
- Messages: `/admin/api/message/`

---

## 🌐 Production Deployment

### PythonAnywhere Steps
1. Upload code
2. Create virtualenv
3. Install requirements
4. Configure MySQL
5. Update settings.py
6. Run migrations
7. Collect static
8. Configure WSGI
9. Reload web app

See **DEPLOY.md** for detailed instructions.

---

## 📞 URLs

| Service | URL |
|---------|-----|
| Local API | http://localhost:8000/api/ |
| Local Admin | http://localhost:8000/admin/ |
| API Docs | http://localhost:8000/api/ (browsable) |

---

## 💾 Backup Strategy

### Daily Backups
```bash
# Database
python manage.py dumpdata > backup_$(date +%Y%m%d).json

# Media files
tar -czf media_backup_$(date +%Y%m%d).tar.gz media/
```

### Restore
```bash
# Database
python manage.py loaddata backup_20251207.json

# Media
tar -xzf media_backup_20251207.tar.gz
```

---

**Quick Reference v1.0** | Django Portfolio Backend | December 2025
