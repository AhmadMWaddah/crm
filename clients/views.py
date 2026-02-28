from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib import messages
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
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
        return Client.objects.filter(user=self.request.user)


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
        return super().delete(request, *args, **kwargs)
