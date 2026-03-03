![Django](https://github.com/AhmadMWaddah/crm/blob/master/CRM_Thumbnail.png)

# Django CRM - Client Management System

A modern, full-featured Client Management System built with Django, designed for freelancers and small businesses to manage their clients and projects efficiently.

![Django](https://img.shields.io/badge/Django-6.0.2-green.svg)
![Python](https://img.shields.io/badge/Python-3.12-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 🌟 Features

- **User Authentication** - Secure signup, login, and logout
- **Client Management** - Full CRUD operations with clickable names and detail modals
- **Project Management** - Track projects with status, rates, and clickable details
- **Live Search** - HTMX-powered real-time search for clients
- **Status Filtering** - Filter projects by status (Active, Completed, On Hold)
- **Dashboard** - Visual statistics with Chart.js (responsive bar/doughnut charts)
- **Responsive Tables** - Mobile-friendly card layout with data-labels
- **Mobile Side Menu** - Slide-in navigation from right with dimmed overlay
- **Performance Optimized** - Database indexes, query optimization, and smart caching
- **Git Workflow** - Professional branch-per-phase development workflow

## 🚀 Quick Start

### Prerequisites

- Python 3.12+
- pip
- Virtual environment (venv)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AhmadMWaddah/crm.git
   cd crm
   ```

2. **Create and activate virtual environment**
   ```bash
   python3 -m venv .env_crm
   source .env_crm/bin/activate  # On Windows: .env_crm\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

5. **Run migrations**
   ```bash
   python manage.py migrate
   ```

6. **Create a superuser**
   ```bash
   python manage.py createsuperuser
   ```

7. **Start the development server**
   ```bash
   python manage.py runserver
   ```

8. **Access the application**
   - Main App: http://127.0.0.1:8000/
   - Admin Panel: http://127.0.0.1:8000/admin/

## 📁 Project Structure

```
crm/
├── accounts/              # User authentication app
├── clients/               # Client management app
├── projects/              # Project management app
├── crm_project/           # Django project settings
├── scripts/               # Automation scripts
│   ├── dev.sh            # Development server
│   ├── setup.sh          # Initial setup
│   ├── test.sh           # Run tests
│   ├── clean.sh          # Cleanup
│   ├── git-commit-phase.sh   # Git commit helper
│   └── git-merge-phase.sh    # Git merge helper
├── static/                # Custom static files (CSS, JS)
├── staticfiles/           # Collected static files
├── .env                   # Environment variables (not committed)
├── .env.example           # Environment template
├── requirements.txt       # Production dependencies
├── requirements-dev.txt   # Development dependencies
└── manage.py              # Django management script
```

## 🛠️ Development

### Using the Automation Scripts

```bash
# Run development server
./scripts/dev.sh

# Run tests
./scripts/test.sh

# Clean project
./scripts/clean.sh

# Commit phase changes
./scripts/git-commit-phase.sh <phase_number> "<message>"

# Merge phase to master
./scripts/git-merge-phase.sh <phase_number>
```

### Git Workflow

This project uses a branch-per-phase workflow:
- Each phase is developed in its own branch (`phase-1`, `phase-2`, etc.)
- Completed phases are merged into `master`
- All work is tracked and pushed to GitHub

## 📊 Tech Stack

- **Backend**: Django 6.0
- **Database**: SQLite (dev) / PostgreSQL (production)
- **Frontend**: HTML5, CSS3, JavaScript
- **Libraries**:
  - HTMX for dynamic interactions
  - Chart.js for data visualization (responsive charts)
  - WhiteNoise for static file serving
- **Development**:
  - Pre-commit hooks (Black, Flake8, isort)
  - Django Debug Toolbar
  - GitHub CLI integration

## 🚢 Deployment

### Deploy to Render + Supabase (FREE)

**Part 1: Create Supabase Database**

1. **Sign up** at [Supabase](https://supabase.com) (no credit card needed)
2. Click **"New Project"**
3. Fill in:
   - **Organization**: Your name
   - **Project name**: `django-crm`
   - **Database password**: Choose a strong password (save this!)
   - **Region**: Choose closest to you
4. Click **"Create new project"**
5. Wait 2-3 minutes for database to be ready
6. Go to **Settings** → **Database**
7. Under **"Connection string"**, select **URI** tab
8. **Copy the connection string** (looks like):
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
   ```
9. **Replace `[YOUR-PASSWORD]`** with your actual database password

**Part 2: Create Render Web Service**

1. **Sign up** at [Render](https://render.com) (use GitHub for easiest setup)
2. Click **"New +"** → **"Web Service"**
3. **Connect your repository**:
   - Choose **"Connect a repository"**
   - Select your CRM repository from GitHub
4. **Configure the service**:
   ```
   Name: django-crm
   Region: Choose closest to you
   Branch: master
   Root Directory: (leave blank)
   Runtime: Python
   Build Command: pip install -r requirements.txt
   Start Command: gunicorn crm_project.wsgi:application
   Instance Type: Free
   ```
5. **Add Environment Variables** (click "Advanced" → "Add Environment Variable"):
   ```
   Key: SECRET_KEY
   Value: (generate from Python: python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")

   Key: DEBUG
   Value: False

   Key: ALLOWED_HOSTS
   Value: <your-app-name>.onrender.com

   Key: DATABASE_URL
   Value: postgresql://postgres:YourPassword123@db.xxxxx.supabase.co:5432/postgres?sslmode=require
   ```
6. Click **"Create Web Service"**
7. Wait 5-10 minutes for deployment
8. Your app is live at: `https://<your-app-name>.onrender.com`

**Part 3: Final Setup**

After deployment, access the **Render dashboard** → **Logs** to see the deployment logs.

To create a superuser, use the **Render Shell**:
1. Go to your service dashboard
2. Click **"Shell"** tab
3. Run:
   ```bash
   python manage.py createsuperuser
   ```

### Environment Variables for Production

```env
SECRET_KEY=your-production-secret-key
DEBUG=False
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
DATABASE_URL=postgresql://user:password@host:port/dbname
```

## 📝 API Endpoints

| Endpoint | Description | Auth Required |
|----------|-------------|---------------|
| `/` | Dashboard redirect | Yes |
| `/dashboard/` | User dashboard with stats & charts | Yes |
| `/accounts/login/` | Login page | No |
| `/accounts/signup/` | Registration page | No |
| `/accounts/logout/` | Logout | Yes |
| `/clients/` | Client list (responsive cards on mobile) | Yes |
| `/clients/new/` | Create client | Yes |
| `/clients/<id>/` | Edit client | Yes |
| `/clients/<id>/delete/` | Delete client | Yes |
| `/projects/` | Project list with status filter | Yes |
| `/projects/new/` | Create project | Yes |
| `/projects/<id>/` | Edit project | Yes |
| `/projects/<id>/delete/` | Delete project | Yes |
| `/admin/` | Admin panel | Superuser |

## 🎯 Key Features Explained

### Live Search
Type in the client search box to filter clients in real-time using HTMX. No page reloads! Filters by name, email, or phone.

### Responsive Tables (Mobile-First)
- **Desktop**: Full table with all columns
- **Mobile**: Transforms to card layout with data-labels
- **Priority Hiding**: Less important columns hidden on mobile
- **Clickable Names**: Tap client/project name to see full details in modal

### Mobile Side Menu
- **Slide-in from right** with smooth animation
- **Dimmed overlay** (50% opacity) covers page
- **Direct logout button** (big red button, impossible to miss)
- **Close options**: × button, tap overlay, or ESC key

### Project Status Tracking
Projects can be marked as Active, Completed, or On Hold. Filter by status using the dropdown. Color-coded indicators.

### Dashboard Analytics
View your business metrics at a glance:
- Total clients and projects
- Active projects count
- **Responsive Chart**: Doughnut on desktop, horizontal bar on mobile
- **Legend shows all statuses** with color coding
- Recent clients and projects
- Quick actions grid (2x2 on mobile, row on desktop)

### Smart Caching
- Dashboard cached per user (5 minutes)
- Cache automatically cleared when data changes
- No need to logout/login to see updated stats

### User Isolation
Each user can only see and manage their own clients and projects. Data is completely isolated with database-level security.

## 📱 Mobile Features

| Feature | Desktop | Mobile |
|---------|---------|--------|
| **Navigation** | Horizontal menu | Side slide-in menu (from right) |
| **Tables** | Full table view | Card layout with labels |
| **Chart** | Doughnut chart | Horizontal bar chart |
| **Quick Actions** | Single row | 2x2 grid |
| **Data Display** | All columns visible | Priority columns + modal for details |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

**Ahmad MWaddah**
- GitHub: [@AhmadMWaddah](https://github.com/AhmadMWaddah)
- Project: Django CRM

## 🙏 Acknowledgments

- Django community
- HTMX contributors
- All open-source contributors

---

**Built with ❤️ using Django**
