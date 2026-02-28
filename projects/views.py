from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib import messages
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from .models import Project
from .forms import ProjectForm


class ProjectListView(LoginRequiredMixin, ListView):
    """List all projects for the logged-in user."""
    model = Project
    template_name = 'projects/project_list.html'
    context_object_name = 'projects'
    login_url = 'login'

    def get_queryset(self):
        """Only return projects belonging to the logged-in user."""
        queryset = Project.objects.filter(user=self.request.user).select_related('client')
        
        # Handle status filtering
        status = self.request.GET.get('status', '')
        if status:
            queryset = queryset.filter(status=status)
        
        return queryset

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_status'] = self.request.GET.get('status', '')
        context['status_choices'] = Project.STATUS_CHOICES
        return context


class ProjectCreateView(LoginRequiredMixin, CreateView):
    """Create a new project."""
    model = Project
    form_class = ProjectForm
    template_name = 'projects/project_form.html'
    success_url = reverse_lazy('project_list')
    login_url = 'login'

    def get_form(self, form_class=None):
        """Filter client queryset to only show user's clients."""
        form = super().get_form(form_class)
        form.fields['client'].queryset = form.fields['client'].queryset.filter(user=self.request.user)
        return form

    def form_valid(self, form):
        """Set the user field to the current user before saving."""
        form.instance.user = self.request.user
        messages.success(self.request, 'Project created successfully!')
        return super().form_valid(form)


class ProjectUpdateView(LoginRequiredMixin, UpdateView):
    """Update an existing project."""
    model = Project
    form_class = ProjectForm
    template_name = 'projects/project_form.html'
    success_url = reverse_lazy('project_list')
    login_url = 'login'

    def get_queryset(self):
        """Only allow users to update their own projects."""
        return Project.objects.filter(user=self.request.user)

    def get_form(self, form_class=None):
        """Filter client queryset to only show user's clients."""
        form = super().get_form(form_class)
        form.fields['client'].queryset = form.fields['client'].queryset.filter(user=self.request.user)
        return form

    def form_valid(self, form):
        """Show success message after update."""
        messages.success(self.request, 'Project updated successfully!')
        return super().form_valid(form)


class ProjectDeleteView(LoginRequiredMixin, DeleteView):
    """Delete a project."""
    model = Project
    template_name = 'projects/project_confirm_delete.html'
    success_url = reverse_lazy('project_list')
    login_url = 'login'

    def get_queryset(self):
        """Only allow users to delete their own projects."""
        return Project.objects.filter(user=self.request.user)

    def delete(self, request, *args, **kwargs):
        """Show success message after deletion."""
        messages.success(request, 'Project deleted successfully!')
        return super().delete(request, *args, **kwargs)
