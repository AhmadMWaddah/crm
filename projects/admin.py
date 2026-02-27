from django.contrib import admin
from .models import Project


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ('name', 'client', 'status', 'rate', 'created_at')
    search_fields = ('name', 'description', 'client__name')
    list_filter = ('status', 'created_at')
    list_select_related = ('client',)
    date_hierarchy = 'created_at'
