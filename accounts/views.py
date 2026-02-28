from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.decorators import login_required
from django.views.generic import CreateView, View
from django.urls import reverse_lazy


@login_required
def dashboard(request):
    """Dashboard view showing summary for logged-in user."""
    from clients.models import Client
    from projects.models import Project
    
    # Get counts for the logged-in user
    clients_count = Client.objects.filter(user=request.user).count()
    projects_count = Project.objects.filter(user=request.user).count()
    active_projects_count = Project.objects.filter(user=request.user, status='active').count()
    
    context = {
        'clients_count': clients_count,
        'projects_count': projects_count,
        'active_projects_count': active_projects_count,
    }
    return render(request, 'accounts/dashboard.html', context)


class SignupView(CreateView):
    """Handle user registration."""
    form_class = UserCreationForm
    template_name = 'accounts/signup.html'
    success_url = reverse_lazy('login')

    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect('dashboard')
        return super().dispatch(request, *args, **kwargs)

    def form_valid(self, form):
        response = super().form_valid(form)
        return response


class LoginView(View):
    """Handle user login."""
    template_name = 'accounts/login.html'

    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect('dashboard')
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        form = AuthenticationForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('dashboard')
        return render(request, self.template_name, {'form': form})


class CustomLogoutView(View):
    """Handle user logout."""
    
    def get(self, request, *args, **kwargs):
        """Handle logout via GET request."""
        from django.contrib.auth import logout
        logout(request)
        return redirect('login')
    
    def post(self, request, *args, **kwargs):
        """Handle logout via POST request."""
        from django.contrib.auth import logout
        logout(request)
        return redirect('login')
