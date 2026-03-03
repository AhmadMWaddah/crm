from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib import messages
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.views import View
from django.urls import reverse_lazy
from django.db.models import Q
from django.core.cache import cache
from .models import Client
from .forms import ClientForm


class ClientListView(LoginRequiredMixin, ListView):
    """List all clients for the logged-in user."""
    model = Client
    template_name = 'clients/client_list.html'
    context_object_name = 'clients'
    login_url = 'login'

    def get_queryset(self):
        """Only return clients belonging to the logged-in user."""
        queryset = Client.objects.filter(user=self.request.user)
        
        # Handle search filtering
        search_query = self.request.GET.get('search', '')
        if search_query:
            queryset = queryset.filter(
                Q(name__icontains=search_query) |
                Q(email__icontains=search_query) |
                Q(phone__icontains=search_query)
            )
        
        return queryset

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['search_query'] = self.request.GET.get('search', '')
        return context


class ClientCreateView(LoginRequiredMixin, CreateView):
    """Create a new client."""
    model = Client
    form_class = ClientForm
    template_name = 'clients/client_form.html'
    success_url = reverse_lazy('client_list')
    login_url = 'login'

    def form_valid(self, form):
        """Set the user field to the current user before saving."""
        form.instance.user = self.request.user
        messages.success(self.request, 'Client created successfully!')
        # Clear dashboard cache for this user
        cache.delete(f'dashboard_user_{self.request.user.id}')
        return super().form_valid(form)


class ClientUpdateView(LoginRequiredMixin, UpdateView):
    """Update an existing client."""
    model = Client
    form_class = ClientForm
    template_name = 'clients/client_form.html'
    success_url = reverse_lazy('client_list')
    login_url = 'login'

    def get_queryset(self):
        """Only allow users to update their own clients."""
        return Client.objects.filter(user=self.request.user)

    def form_valid(self, form):
        """Show success message after update."""
        messages.success(self.request, 'Client updated successfully!')
        # Clear dashboard cache for this user
        cache.delete(f'dashboard_user_{self.request.user.id}')
        return super().form_valid(form)


class ClientDeleteView(LoginRequiredMixin, DeleteView):
    """Delete a client."""
    model = Client
    template_name = 'clients/client_confirm_delete.html'
    success_url = reverse_lazy('client_list')
    login_url = 'login'

    def get_queryset(self):
        """Only allow users to delete their own clients."""
        return Client.objects.filter(user=self.request.user)

    def delete(self, request, *args, **kwargs):
        """Show success message after deletion."""
        messages.success(request, 'Client deleted successfully!')
        # Clear dashboard cache for this user
        cache.delete(f'dashboard_user_{request.user.id}')
        return super().delete(request, *args, **kwargs)


class ClientProjectsView(LoginRequiredMixin, View):
    """HTMX view to load projects for a specific client."""
    
    def get(self, request, pk):
        client = get_object_or_404(Client, pk=pk, user=request.user)
        projects = client.projects.all()
        return render(request, 'clients/partials/client_projects.html', {
            'client': client,
            'projects': projects
        })


class ClientSearchView(LoginRequiredMixin, View):
    """HTMX view for live client search."""
    
    def get(self, request):
        search_query = request.GET.get('search', '')
        
        clients = Client.objects.filter(user=request.user)
        if search_query:
            clients = clients.filter(
                Q(name__icontains=search_query) |
                Q(email__icontains=search_query) |
                Q(phone__icontains=search_query)
            )
        
        return render(request, 'clients/partials/client_list_body.html', {
            'clients': clients,
            'search_query': search_query
        })
