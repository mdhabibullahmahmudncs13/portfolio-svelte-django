# Portfolio - SvelteKit + Django

A modern, dynamic portfolio website with SvelteKit frontend and Django REST API backend.

## 📁 Project Structure

```
portfolio-svelte-django/
├── backend/                 # Django REST API
│   ├── api/                # API app with models, views, serializers
│   ├── portfolio_backend/  # Django project settings
│   ├── manage.py
│   └── requirements.txt
│
├── frontend/               # SvelteKit app
│   ├── src/
│   │   ├── lib/           # Utilities, types, API client
│   │   └── routes/        # SvelteKit routes
│   ├── package.json
│   └── svelte.config.js
│
└── README.md
```

## 🚀 Features

- **Public Portfolio Pages**: Hero, Skills, Projects, Experience, Certifications, Contact, Blog
- **Admin Panel**: Secure content management at `/xenon` (login at `/whoami`)
- **Contact Form**: Message submissions stored in database
- **File Uploads**: Images, videos, PDFs support
- **RESTful API**: Django REST Framework with JWT authentication
- **Modern UI**: TailwindCSS, dark theme, responsive design

## 🛠️ Tech Stack

**Frontend:**
- SvelteKit 2.0
- TypeScript
- TailwindCSS
- Vite

**Backend:**
- Django 4.2+
- Django REST Framework
- Simple JWT
- PostgreSQL (production) / SQLite (development)

## 📦 Installation

### Backend Setup

```bash
cd backend

# Install dependencies (create virtual environment first if needed)
pip install -r requirements.txt

# Copy environment file
cp .env.example .env

# Run migrations
python manage.py makemigrations
python manage.py migrate

# Create superuser for admin access
python manage.py createsuperuser

# Run development server
python manage.py runserver
```

The API will be available at `http://localhost:8000/api/`

### Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Run development server
npm run dev
```

The frontend will be available at `http://localhost:5173`

## 🔐 Authentication

1. Create a superuser in Django: `python manage.py createsuperuser`
2. Login at `/whoami` using your credentials
3. Access admin panel at `/xenon`

## 📡 API Endpoints

### Public Endpoints
- `GET /api/hero/` - Get hero section data
- `GET /api/skills/` - List all skills
- `GET /api/projects/` - List all projects
- `GET /api/experience/` - List experience
- `GET /api/certifications/` - List certifications
- `GET /api/contact/` - Get contact information
- `POST /api/messages/` - Submit contact form
- `GET /api/blog/` - List published blog posts

### Admin Endpoints (Require JWT Token)
- All POST, PUT, PATCH, DELETE operations
- `GET /api/messages/` - View all messages
- POST `/api/token/` - Obtain JWT token
- POST `/api/token/refresh/` - Refresh JWT token

## 🌐 Environment Variables

### Backend (.env)
```
SECRET_KEY=your-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://127.0.0.1:5173
```

### Frontend (.env)
```
PUBLIC_API_URL=http://localhost:8000/api
```

## 🚢 Deployment

### Backend (Railway/Render/Heroku)
1. Set environment variables
2. Use PostgreSQL database
3. Run `python manage.py collectstatic`
4. Set `DEBUG=False` in production

### Frontend (Vercel)
1. Connect GitHub repository
2. Set `PUBLIC_API_URL` to your backend URL
3. Deploy

## 📝 Models

- **Hero**: Portfolio owner information
- **Skill**: Technical skills with proficiency levels
- **Project**: Portfolio projects with images/videos
- **Experience**: Work experience timeline
- **Certification**: Certifications and courses
- **Contact**: Contact information
- **Message**: Contact form submissions
- **BlogPost**: Blog articles with markdown support

## 🔧 Development

### Run Backend Tests
```bash
cd backend
python manage.py test
```

### Build Frontend
```bash
cd frontend
npm run build
```

## 📄 License

MIT License

## 👤 Author

Your Name
