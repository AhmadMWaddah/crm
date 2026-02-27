# Django CRM Project Plan

## How to Use This Plan

- Copy this entire markdown into your AI tool's context (or paste it as a system prompt).
- Work through each phase sequentially. For each task, ask the AI to explain concepts and generate code.
- Don't just accept code blindly. After the AI provides code, read it, modify it, break it, and fix it. Use the AI to explain parts you don't understand.
- Commit your code to Git after each working feature.
- Deploy early so you can see your app live.

---

## Project Overview

Build a **Client Management System** for freelancers or small businesses. Users can:

- Register and log in.
- Manage clients (add, edit, delete, view).
- Manage projects (add, edit, delete, view) linked to clients.
- Search/filter clients and projects.
- See a dashboard with summary counts.
- Use HTMX for a smoother experience (inline editing, dynamic search, modals).

### Tech Stack

- **Django** (Python)
- **SQLite** (development) / **PostgreSQL** (production)
- **SASS** (For Frontend)
- **HTMX** + `django-htmx`
- *(Optional)* Alpine.js for lightweight interactions

---

## Phase 1: Project Setup

**Goal:** Create a Django project and app, verify everything works.

**Concepts:** Virtual environments, Django project structure, running the server.

### Tasks

1. Create a virtual environment named `.env_crm` and activate it.
2. Install Django.
3. Start a new Django project (e.g., `crm_project`).
4. Start a new app (e.g., `crm`).
5. Add the app to `INSTALLED_APPS`.
6. Run migrations and start the development server.
7. Verify you see the Django welcome page.

### AI Prompts

- "Explain how to set up a Django project with a virtual environment named `.env_crm`."
- "Generate the commands to create a Django project and app called 'crm'."
- "What files are created and what do they do?"

---

## Phase 2: Environment Variables & Configuration Files

**Goal:** Set up environment variables for sensitive configuration and create essential configuration files.

**Concepts:** Environment variables, `.env` files, `python-decouple` or `django-environ`, separating secrets from code.

### Tasks

1. Install `python-decouple` (or `django-environ`):
   ```bash
   pip install python-decouple
   ```

2. Create a `.env` file in the project root with:
   - `SECRET_KEY` (generate a secure random key)
   - `DEBUG=True`
   - `ALLOWED_HOSTS=localhost,127.0.0.1`
   - `DATABASE_URL=sqlite:///db.sqlite3`
   - `EMAIL_HOST_USER` (optional, for later)
   - `EMAIL_HOST_PASSWORD` (optional, for later)

3. Update `settings.py` to read from `.env`:
   - Import `config` from `decouple`
   - Replace hardcoded `SECRET_KEY` with `config('SECRET_KEY')`
   - Replace `DEBUG` with `config('DEBUG', default=False, cast=bool)`
   - Replace `ALLOWED_HOSTS` with `config('ALLOWED_HOSTS', default='').split(',')`

4. Create a `.env.example` file with placeholder values (safe to commit).

5. Create a `.gitignore` file that ignores:
   - `.env` (never commit secrets)
   - `.env_crm/` (virtual environment)
   - `__pycache__/`
   - `*.pyc`
   - `db.sqlite3`
   - `staticfiles/`
   - `media/`
   - `.sass-cache/`
   - `*.css.map`
   - `node_modules/`
   - `.DS_Store`
   - `*.log`

### AI Prompts

- "Explain why we use environment variables in Django and what should never be committed to Git."
- "How do I use python-decouple to read environment variables in Django settings?"
- "Generate a comprehensive .gitignore file for a Django project with Python, Bash, JavaScript, and SASS."
- "What's the difference between .env and .env.example? When should I use each?"

---

## Phase 3: Pre-commit Hooks

**Goal:** Set up pre-commit hooks to automatically check code quality before each commit.

**Concepts:** Git hooks, pre-commit framework, code linting, automated checks.

### Tasks

1. Install pre-commit:
   ```bash
   pip install pre-commit
   ```

2. Create a `.pre-commit-config.yaml` file in the project root with hooks for:
   - `trailing-whitespace` (removes trailing whitespace)
   - `end-of-file-fixer` (ensures files end with a newline)
   - `check-yaml` (validates YAML syntax)
   - `check-added-large-files` (prevents committing large files)
   - `black` (Python code formatter)
   - `flake8` (Python linting)
   - `isort` (Python import sorting)

3. Install the git hook scripts:
   ```bash
   pre-commit install
   ```

4. Run pre-commit on all files:
   ```bash
   pre-commit run --all-files
   ```

5. Commit the configuration and test that hooks run on commit.

### AI Prompts

- "Explain what pre-commit hooks are and why they're useful for a Django project."
- "Generate a .pre-commit-config.yaml file with hooks for Python, YAML, and whitespace checks."
- "How do I install and test pre-commit hooks in my Git repository?"
- "What's the difference between black, flake8, and isort? Do I need all three?"

---

## Phase 4: Development Bash Scripts

**Goal:** Create reusable bash scripts to automate common development tasks.

**Concepts:** Bash scripting, Django management commands, automation.

### Tasks

1. Create a `scripts/` directory in the project root.

2. Create `scripts/dev.sh` for development workflow:
   - Activate virtual environment (`.env_crm`)
   - Run `makemigrations`
   - Run `migrate`
   - Collect static files (`collectstatic --noinput`)
   - Run the development server (`runserver`)
   - Make it executable: `chmod +x scripts/dev.sh`

3. Create `scripts/setup.sh` for initial project setup:
   - Check if virtual environment exists, create if not
   - Activate virtual environment
   - Install dependencies from `requirements.txt`
   - Install pre-commit hooks
   - Run migrations
   - Create a superuser (optional prompt)
   - Make it executable: `chmod +x scripts/setup.sh`

4. Create `scripts/test.sh` for running tests:
   - Activate virtual environment
   - Run Django tests with coverage (`pytest` or `python manage.py test`)
   - Run pre-commit checks
   - Make it executable: `chmod +x scripts/test.sh`

5. Create `scripts/clean.sh` for cleanup:
   - Remove `__pycache__` directories
   - Remove `.pyc` files
   - Remove `db.sqlite3` (with confirmation)
   - Make it executable: `chmod +x scripts/clean.sh`

### AI Prompts

- "Generate a bash script that runs makemigrations, migrate, collectstatic, and runserver for Django development."
- "How do I write a bash script that checks if a virtual environment exists and creates it if not?"
- "Create a cleanup script that removes Python cache files and optionally deletes the database."
- "Explain how to make a bash script executable and how to run it."

---

## Phase 5: Git Workflow & Branch Strategy

**Goal:** Set up a Git repository with a branch-per-phase workflow for organized development.

**Concepts:** Git branching, merging, pull requests, version control best practices.

### Tasks

1. Initialize Git repository:
   ```bash
   git init
   ```

2. Set up branch protection:
   - Rename default branch to `master`: `git branch -M master`
   - Create an initial commit with the project structure

3. Create `scripts/git-commit-phase.sh` for committing and pushing to phase branch:
   - Accept phase number and message as arguments (e.g., `./scripts/git-commit-phase.sh 1 "Completed models and admin"`)
   - Check if a branch `phase-{n}` exists; if not, create it from `master`
   - Checkout the phase branch
   - Stage all changes (`git add .`)
   - Commit with a formatted message: "Phase {n}: {message}"
   - Push the phase branch to remote (create upstream if needed)
   - Make it executable: `chmod +x scripts/git-commit-phase.sh`

4. Create `scripts/git-merge-phase.sh` for merging phase into master:
   - Accept phase number as argument (e.g., `./scripts/git-merge-phase.sh 1`)
   - Checkout `master`
   - Pull latest changes from remote
   - Merge `phase-{n}` into `master`
   - Push `master` to remote
   - Optionally delete the phase branch locally and remotely
   - Make it executable: `chmod +x scripts/git-merge-phase.sh`

5. Create `.github/CODEOWNERS` (optional, for GitHub).

6. Push initial structure to GitHub:
   ```bash
   git remote add origin <your-repo-url>
   git push -u origin master
   ```

### AI Prompts

- "Explain the branch-per-feature workflow and why it's better than committing directly to master."
- "Generate a bash script that creates a phase branch, stages changes, commits with a message, and pushes to GitHub."
- "Generate a bash script that merges a phase branch into master and pushes the result."
- "How do I merge a feature branch into master only if tests pass?"
- "What's a pull request and when should I use one?"

---

## Phase 6: Requirements & Dependencies File

**Goal:** Create and maintain a `requirements.txt` file for reproducible environments.

**Concepts:** Python dependencies, pip freeze, reproducible builds.

### Tasks

1. Generate initial `requirements.txt`:
   ```bash
   pip freeze > requirements.txt
   ```

2. Clean up `requirements.txt`:
   - Remove system-specific packages
   - Organize by category (Django, HTMX, dev tools, etc.)
   - Add version pins for production

3. Create `requirements-dev.txt` for development-only dependencies:
   - `pre-commit`
   - `black`
   - `flake8`
   - `pytest` (optional)
   - `pytest-cov` (optional)
   - Reference main requirements: `-r requirements.txt`

4. Update `setup.sh` to install from both files.

### AI Prompts

- "What's the difference between requirements.txt and requirements-dev.txt?"
- "How do I generate a clean requirements.txt file without system-specific packages?"
- "Should I pin exact versions or use minimum versions in requirements.txt?"

---

## Phase 7: Models and Admin

**Goal:** Define `Client` and `Project` models, register them in admin, and create migrations.

**Concepts:** Django models, fields, relationships (ForeignKey), choices, migrations, admin interface.

### Tasks

1. Define `Client` model with fields:
   - `name` (CharField)
   - `email` (EmailField, optional)
   - `phone` (CharField, optional)
   - `created_at` (DateTimeField, auto-now-add)

2. Define `Project` model with fields:
   - `name` (CharField)
   - `description` (TextField, optional)
   - `status` (CharField with choices: `'active'`, `'completed'`, `'on_hold'`)
   - `rate` (DecimalField, help_text="Hourly rate in EGP")
   - `client` (ForeignKey to Client, on_delete=models.CASCADE)
   - `created_at` (DateTimeField, auto-now-add)

3. Run `makemigrations` and `migrate`.
4. Register both models in `admin.py`.
5. Add some sample data via admin.

### AI Prompts

- "Generate Django models for Client and Project with the fields I described. Include choices for status."
- "Explain what a ForeignKey does and what `on_delete=models.CASCADE` means."
- "How do I register models in the admin and customize the list display?"

---

## Phase 8: User Authentication & Ownership

**Goal:** Users can sign up, log in, and log out. Each user sees only their own clients and projects.

**Concepts:** Django's built-in authentication, `@login_required`, linking models to User, filtering querysets by user.

### Tasks

1. Add `django.contrib.auth` to `INSTALLED_APPS` (already there by default).
2. Create templates for login, logout, and signup (use `UserCreationForm` for signup).
3. Add URL patterns for auth views (or create your own views).
4. Modify `Client` and `Project` models to include a `user` ForeignKey to `settings.AUTH_USER_MODEL`.
5. Make and apply migrations.
6. Update admin to show the user field.
7. In views, ensure that only objects belonging to the logged-in user are displayed (filter querysets by `request.user`).
8. Protect views with `@login_required`.

### AI Prompts

- "How do I add user authentication to my Django project? Show me the URLs, views, and templates for login, logout, and signup."
- "How do I add a ForeignKey to the User model in my Client and Project models?"
- "Write a view that lists only the clients belonging to the logged-in user."
- "Explain how `@login_required` works and what happens when an unauthenticated user tries to access a protected view."

---

## Phase 9: CRUD for Clients

**Goal:** Create pages to list, add, edit, and delete clients.

**Concepts:** Class-Based Views (ListView, CreateView, UpdateView, DeleteView), forms, URL routing, templates.

### Tasks

1. Create a `ClientListView` that shows all clients for the logged-in user.
2. Create a template `client_list.html` that displays clients in a table.
3. Add a link to "Add Client".
4. Create a `ClientCreateView` that uses a ModelForm and automatically sets the `user` field to the current user.
5. Create a template `client_form.html` (reusable for add/edit).
6. Create a `ClientUpdateView` similar to create.
7. Create a `ClientDeleteView` with a confirmation template.
8. Add URLs for each view.

### AI Prompts

- "Generate a Django ListView for Client that filters by the logged-in user."
- "How do I create a CreateView that automatically sets the user field to `request.user`? Show me how to override `form_valid`."
- "Write a Bootstrap-styled form template for my Client model."
- "What's the difference between CreateView and UpdateView? How does Django know which form to use?"

---

## Phase 10: CRUD for Projects

**Goal:** Similar CRUD for projects, with a dropdown to select the client (only showing the user's clients).

**Concepts:** ModelForms with filtered querysets, reversing URLs, template inheritance.

### Tasks

1. Create `ProjectListView` similar to clients.
2. Create `ProjectCreateView`. In the form, limit the client choices to the user's clients (override `get_form` or use `ModelChoiceField` queryset).
3. Create `ProjectUpdateView`.
4. Create `ProjectDeleteView`.
5. Add links from client detail page to related projects.

### AI Prompts

- "How do I filter the client dropdown in a Project form so it only shows clients belonging to the logged-in user?"
- "Generate a ProjectCreateView with the filtered client queryset."
- "How can I display all projects for a specific client on the client detail page?"

---

## Phase 11: Basic UI with SASS

**Goal:** Make the app look professional with SASS and a consistent layout.

**Concepts:** Template inheritance, static files, HTML/CSS/JavaScript Custom components.

### Tasks

1. Create a `base.html` with a navbar (Home, Clients, Projects, Dashboard, Login/Logout).
2. Extend `base.html` in all your templates.
3. Style tables, forms, and buttons with SASS classes.
4. Add messages (success/error) using Django's messages framework and Bootstrap alerts.
5. Create the SASS directory as smaller modules, and combine it with imports.

### AI Prompts

- "Give me a SASS base template with a responsive navbar and a container for content."
- "How do I display Django messages for alerts using SASS Styled Components?"
- "Style my client list table with Custom table classes."

---

## Phase 12: HTMX Interactivity

**Goal:** Add dynamic features without page reloads using HTMX.

**Concepts:** HTMX attributes, server-rendered partials, `django-htmx`.

### Tasks

1. Install `django-htmx` and add it to `INSTALLED_APPS` and `MIDDLEWARE`.
2. Add HTMX script to base template:
```html
   <script src="https://unpkg.com/htmx.org@1.9.12"></script>
```
3. On the client list page, add a button for each client that fetches and displays a list of projects via HTMX:
   - Create a partial template `client_projects.html`.
   - Create a view that returns only that partial.
   - Use `hx-get` and `hx-target` to load the content into a div.
4. Implement inline editing of a client's phone number:
   - Create a view that updates a single field.
   - Use `hx-post` and `hx-swap`.
5. Add a modal form for quick project creation using HTMX.

### AI Prompts

- "Explain how HTMX works and how to use it with Django."
- "How do I create a Django view that returns a partial template for HTMX?"
- "Write the code for an HTMX button that loads a list of projects for a client when clicked."
- "How can I do inline editing with HTMX? Show an example for updating a client's phone."

---

## Phase 13: Search and Filtering

**Goal:** Add search functionality to client and project lists, with live updates via HTMX.

**Concepts:** Django Q objects, filtering, HTMX form submission.

### Tasks

1. On the client list page, add a search input that filters by name or email.
2. Use HTMX to send the search query to the server and update the table dynamically:
   - Wrap the table in a `div` with an `id`.
   - Make the search input trigger a GET request with `hx-get` and `hx-trigger="keyup changed delay:500ms"`.
   - Create a view that filters clients and returns the partial table.
3. Similarly add filtering by status on the project list.

### AI Prompts

- "How do I filter a Django queryset by multiple fields using Q objects?"
- "Write a view that accepts a search query and returns a filtered list of clients as an HTML partial."
- "How do I use HTMX to send a search term to the server and update the table?"

---

## Phase 14: Dashboard with Statistics

**Goal:** Create a dashboard showing summary counts and simple charts.

**Concepts:** Django aggregations, annotations, Chart.js.

### Tasks

1. Create a `DashboardView` that gathers:
   - Total clients
   - Total projects
   - Projects by status (counts)
2. Pass this data to a template.
3. Use Chart.js to display a bar chart of projects by status.
4. Optionally add a list of recent clients or projects.

### AI Prompts

- "How do I use Django's `aggregate` and `annotate` to count projects by status?"
- "Generate a dashboard template with Chart.js that displays a bar chart of project statuses."
- "How do I pass context data to a template in a class-based view?"

---

## Phase 15: Performance Optimization

**Goal:** Optimize the application for better performance and learn debugging tools.

**Concepts:** Django Debug Toolbar, query optimization (select_related, prefetch_related), caching, database indexes.

### Tasks

1. Install and configure **Django Debug Toolbar**:
   - Add to `INSTALLED_APPS` and `MIDDLEWARE`
   - Configure `INTERNAL_IPS`
   - Use it to identify slow queries and N+1 problems

2. Optimize database queries:
   - Use `select_related` for ForeignKey relationships (single-valued)
   - Use `prefetch_related` for ManyToMany and reverse ForeignKey (multi-valued)
   - Add database indexes to frequently queried fields (e.g., `name`, `email`, `status`)
   - Review queries in Debug Toolbar and fix N+1 issues

3. Implement caching:
   - Add per-view caching for the dashboard (using Django's cache framework)
   - Cache template fragments (e.g., sidebar, navbar)
   - Configure cache backend (start with local memory, ready for Redis in production)

4. Optimize static files:
   - Enable `ManifestStaticFilesStorage` for cache-busting filenames
   - Compress CSS/JS if needed

5. Document performance improvements:
   - Record query count before/after optimization
   - Note page load time improvements

### AI Prompts

- "What is the Django Debug Toolbar and how do I install it?"
- "Explain the difference between select_related and prefetch_related with examples."
- "How do I add database indexes to Django model fields?"
- "How do I implement per-view caching in Django? Show me with the dashboard view."
- "What are N+1 queries and how do I fix them?"

---

## Phase 16: Deployment

**Goal:** Deploy the app to a production server so you can share a live demo.

**Concepts:** Environment variables, production settings, static files, deployment platforms.

### Tasks

1. Prepare for production:
   - Create a `requirements.txt` file (already done in Phase 6).
   - Set `DEBUG = False` via environment variable in `.env`.
   - Configure `ALLOWED_HOSTS` via environment variable.
   - Use environment variables for secret key and database URL (already set up in Phase 2).
   - Set up static files with WhiteNoise or a CDN.
   - Create a `Procfile` (for Render) or configure for PythonAnywhere.

2. Set up production environment variables:
   - Copy `.env.example` to `.env.production` (do not commit).
   - Set production `SECRET_KEY` (generate new one).
   - Set `DEBUG=False`.
   - Set `ALLOWED_HOSTS` to your production domain.
   - Set `DATABASE_URL` to PostgreSQL connection string.

3. Choose a free hosting platform: **Render** or **PythonAnywhere**.

4. Follow platform-specific instructions to deploy:
   - **Render**: Connect GitHub repo, set environment variables, deploy.
   - **PythonAnywhere**: Upload code, configure WSGI, set environment variables.

5. Set up a PostgreSQL database (or use the platform's default).

6. Run migrations on production:
   ```bash
   python manage.py migrate
   ```

7. Test the live app.

### AI Prompts

- "What are the steps to deploy a Django app to Render? Include setting environment variables and using WhiteNoise."
- "How do I generate a `requirements.txt` file for my project?"
- "Explain how to configure Django for production with `DEBUG=False` and static files."
- "How do I set environment variables on Render/PythonAnywhere?"
- "What's the difference between SQLite and PostgreSQL? Why use PostgreSQL in production?"

---

## Phase 17: Polish and Interview Prep

**Goal:** Prepare your project for your resume and practice interview questions.

### Tasks

1. Write a clear `README.md` with project description, features, screenshots, and live demo link.
2. Push code to GitHub (make sure no secrets are exposed).
3. Review all concepts you've learned. Be ready to explain:
   - How Django handles a request (URL → view → model → template → response).
   - How authentication works (sessions, cookies, `@login_required`).
   - How the ORM works and how you prevented SQL injection.
   - How HTMX improves user experience.
   - Any challenges you faced and how you solved them.
4. Practice answering common Django interview questions.

### AI Prompts

- "Generate a README template for my Django project."
- "Quiz me on Django concepts for a junior developer interview."
- "What are common Django interview questions and how should I answer them?"

---

## Final Tips for Using AI Effectively

- **Ask for explanations first:** "Explain how Django class-based views work before generating code."
- **Request multiple approaches:** "Show me both a function-based view and a class-based view for this."
- **Debug together:** "I'm getting this error: [paste error]. What does it mean and how do I fix it?"
- **Explore alternatives:** "Is there a simpler way to do this with HTMX?"
- **After getting code, ask:** "Why did you write it that way? What does each part do?"

---

> By following this plan, you'll build a real, portfolio-ready application while learning the essential concepts. You'll be ready to apply for junior Django jobs in 2–3 months. Good luck!

---

## Additional Recommendations

### Optional Advanced Phases

Consider adding these phases if you have extra time:

- **Phase X.1: Automated Testing**
  - Write unit tests for models (test field constraints, methods).
  - Write tests for views (test authentication, permissions, context data).
  - Write tests for forms (test validation, clean methods).
  - Aim for 80%+ code coverage.
  - **AI Prompts:** "How do I write unit tests for Django models and views?", "Explain pytest-django and how it differs from Django's test runner."

- **Phase X.2: API Development**
  - Add Django REST Framework for a JSON API.
  - Create API endpoints for clients and projects.
  - Use the API for HTMX requests instead of HTML partials.
  - **AI Prompts:** "How do I create a REST API with Django REST Framework?", "When should I use an API vs. server-rendered HTML?"

- **Phase X.3: Docker Containerization**
  - Create a `Dockerfile` for the Django app.
  - Create a `docker-compose.yml` with Django + PostgreSQL.
  - Use Docker for local development and deployment.
  - **AI Prompts:** "Explain Docker and why it's useful for Django development.", "Generate a Dockerfile and docker-compose.yml for a Django project."

- **Phase X.4: CI/CD Pipeline**
  - Set up GitHub Actions for automated testing on push.
  - Run tests and pre-commit checks automatically.
  - Deploy automatically on merge to master.
  - **AI Prompts:** "How do I set up GitHub Actions for a Django project?", "Generate a workflow file that runs tests on every push."

### Project Structure Summary

After completing all phases, your project should have:

```
crm_project/
├── .env                          # Local environment variables (NOT committed)
├── .env.example                  # Template for environment variables (committed)
├── .gitignore                    # Git ignore rules
├── .pre-commit-config.yaml       # Pre-commit hooks configuration
├── manage.py                     # Django management script
├── requirements.txt              # Production dependencies
├── requirements-dev.txt          # Development dependencies
├── Procfile                      # Deployment configuration (Render)
├── scripts/
│   ├── dev.sh                    # Development server script
│   ├── setup.sh                  # Initial setup script
│   ├── test.sh                   # Test runner script
│   ├── clean.sh                  # Cleanup script
│   ├── git-commit-phase.sh       # Commit and push to phase branch
│   └── git-merge-phase.sh        # Merge phase into master
├── crm_project/                  # Django project settings
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── crm/                          # Django app
│   ├── migrations/
│   ├── templates/
│   ├── templatetags/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── forms.py
│   ├── models.py
│   ├── urls.py
│   └── views.py
├── static/                       # Static files (SASS, JS, images)
│   ├── sass/
│   ├── js/
│   └── images/
└── media/                        # User-uploaded files
```

### Git Branch Naming Convention

Each phase branch is named after the phase number. After finalizing work on a phase, merge it into `master`:

| Phase | Branch Name | Commit Message Pattern |
|-------|-------------|------------------------|
| 1 | `phase-1` | "Phase 1: Project Setup" |
| 2 | `phase-2` | "Phase 2: Environment Variables & Config" |
| 3 | `phase-3` | "Phase 3: Pre-commit Hooks" |
| 4 | `phase-4` | "Phase 4: Development Bash Scripts" |
| 5 | `phase-5` | "Phase 5: Git Workflow & Branch Strategy" |
| 6 | `phase-6` | "Phase 6: Requirements & Dependencies" |
| 7 | `phase-7` | "Phase 7: Models and Admin" |
| 8 | `phase-8` | "Phase 8: User Authentication & Ownership" |
| 9 | `phase-9` | "Phase 9: CRUD for Clients" |
| 10 | `phase-10` | "Phase 10: CRUD for Projects" |
| 11 | `phase-11` | "Phase 11: Basic UI with SASS" |
| 12 | `phase-12` | "Phase 12: HTMX Interactivity" |
| 13 | `phase-13` | "Phase 13: Search and Filtering" |
| 14 | `phase-14` | "Phase 14: Dashboard with Statistics" |
| 15 | `phase-15` | "Phase 15: Performance Optimization" |
| 16 | `phase-16` | "Phase 16: Deployment" |
| 17 | `phase-17` | "Phase 17: Polish and Interview Prep" |

### Git Scripts Usage

**Commit and push work to a phase branch:**
```bash
# Usage: ./scripts/git-commit-phase.sh <phase_number> "<commit_message>"
./scripts/git-commit-phase.sh 7 "Completed models and admin setup"
```
This will:
1. Create `phase-7` branch from `master` (if it doesn't exist)
2. Checkout to `phase-7`
3. Stage all changes
4. Commit with message "Phase 7: Completed models and admin setup"
5. Push `phase-7` to GitHub

**Merge a completed phase into master:**
```bash
# Usage: ./scripts/git-merge-phase.sh <phase_number>
./scripts/git-merge-phase.sh 7
```
This will:
1. Checkout `master`
2. Pull latest changes
3. Merge `phase-7` into `master`
4. Push `master` to remote
5. Optionally delete `phase-7` branch
