from django.contrib import admin
from .models import Project


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ('name', 'client', 'user', 'status', 'rate', 'created_at')
    search_fields = ('name', 'description', 'client__name', 'user__username')
    list_filter = ('status', 'created_at', 'user')
    list_select_related = ('client', 'user')
    date_hierarchy = 'created_at'
