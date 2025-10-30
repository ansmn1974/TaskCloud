"""
Django admin configuration for tasks app.

Registers Task model with custom display and filtering.
"""
from django.contrib import admin
from .models import Task


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    """
    Admin interface for Task model.
    
    Provides:
    - List display with key fields
    - Filtering by completion status and creation date
    - Search by title and description
    - Read-only fields for auto-generated data
    """
    list_display = ['title', 'is_completed', 'created_at', 'due_date']
    list_filter = ['is_completed', 'created_at']
    search_fields = ['title', 'description']
    readonly_fields = ['id', 'created_at']
    ordering = ['-created_at']
