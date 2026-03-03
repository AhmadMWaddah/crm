# Django CRM - Environment Setup Guide

## ✅ What Was Fixed

### 1. **Database Configuration** (Development vs Production)

**Problem:** Local development was trying to connect to Supabase PostgreSQL, causing "Network is unreachable" errors.

**Solution:** Automatic database switching based on `DEBUG` setting:
- **Development (DEBUG=True)**: Uses SQLite (`db.sqlite3`)
- **Production (DEBUG=False)**: Uses PostgreSQL (Supabase on Render)

### 2. **Responsive Design & Static CSS**

**Problem:** All CSS was inline, not responsive, couldn't use `collectstatic`.

**Solution:** 
- Created comprehensive `static/css/style.css`
- Mobile-first responsive design (phone, tablet, desktop)
- Mobile navigation with hamburger menu
- All templates now use static CSS
- `collectstatic` works for both dev and production

---

## 🚀 How to Use

### **Local Development**

1. **Environment Setup:**
   ```bash
   cd /home/amw/Business/WebDevs/CRM
   source .env_crm/bin/activate
   ```

2. **Database Migrations:**
   ```bash
   python manage.py migrate
   ```
   ✅ Uses SQLite automatically (no Supabase connection needed)

3. **Collect Static Files:**
   ```bash
   python manage.py collectstatic --noinput
   ```

4. **Create Superuser:**
   ```bash
   python manage.py createsuperuser
   ```

5. **Run Development Server:**
   ```bash
   python manage.py runserver
   ```
   Visit: http://127.0.0.1:8000/

---

### **Production Deployment (Render)**

1. **Environment Variables on Render:**
   ```
   SECRET_KEY=<generate-strong-random-key>
   DEBUG=False
   ALLOWED_HOSTS=django-crm-xxxx.onrender.com
   DATABASE_URL=postgresql://postgres:password@host:port/database?sslmode=require
   ```

2. **How It Works:**
   - `DEBUG=False` triggers PostgreSQL configuration
   - Reads `DATABASE_URL` from Render environment
   - Connects to Supabase PostgreSQL
   - WhiteNoise serves static files

3. **Automatic Deployment:**
   - Push to GitHub → Render auto-deploys
   - Runs migrations automatically
   - Collects static files automatically

---

## 📁 Environment Files

### **`.env`** (Local Development)
```env
SECRET_KEY=django-insecure-local-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
DATABASE_URL=sqlite:///db.sqlite3
```

### **`.env.production.template`** (Reference for Render)
```env
SECRET_KEY=<strong-random-key>
DEBUG=False
ALLOWED_HOSTS=your-app.onrender.com
DATABASE_URL=postgresql://postgres:password@host:port/database
```

### **`.env.example`** (Template for new developers)
- Shows both development and production configurations
- Clear instructions for setup

---

## 🎨 Responsive Design Features

### **Desktop (>768px)**
- Full navigation menu
- Multi-column dashboard grid
- Full-width tables

### **Tablet (≤768px)**
- Collapsible navigation
- Single-column stats grid
- Responsive tables with scroll

### **Mobile (≤480px)**
- Hamburger menu
- Stacked layout
- Touch-friendly buttons
- Optimized font sizes

---

## ✅ Testing Checklist

### **Local Development**
- [ ] `python manage.py migrate` works without Supabase
- [ ] `python manage.py collectstatic` copies CSS
- [ ] `python manage.py runserver` starts successfully
- [ ] Site is responsive on mobile/tablet
- [ ] Can create users, clients, projects

### **Production (Render)**
- [ ] Environment variables set correctly
- [ ] `DEBUG=False`
- [ ] `DATABASE_URL` points to Supabase
- [ ] Site loads at `https://your-app.onrender.com`
- [ ] Static files load correctly
- [ ] Database operations work

---

## 🔧 Troubleshooting

### **"Network is unreachable" Error**
**Cause:** Trying to connect to Supabase locally

**Fix:**
1. Check `.env` file has `DEBUG=True`
2. Check `DATABASE_URL=sqlite:///db.sqlite3`
3. Restart development server

### **Static Files Not Loading**
**Cause:** `collectstatic` not run or CSS path wrong

**Fix:**
```bash
python manage.py collectstatic --noinput
```

### **Site Not Responsive**
**Cause:** Browser cache or CSS not loaded

**Fix:**
1. Hard refresh browser (Ctrl+Shift+R)
2. Check browser dev tools for CSS errors
3. Verify `<link>` tag in base.html

---

## 📊 Summary

| Feature | Development | Production |
|---------|-------------|------------|
| **Database** | SQLite | PostgreSQL (Supabase) |
| **DEBUG** | `True` | `False` |
| **Static Files** | Local directory | WhiteNoise (Render) |
| **Environment** | `.env` file | Render dashboard |
| **Server** | `runserver` | Gunicorn |

**Both environments now work seamlessly with the same codebase!** 🎉
