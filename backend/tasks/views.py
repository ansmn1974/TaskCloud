"""
DRF views for Task CRUD operations.

Uses generic class-based views (ListCreateAPIView, RetrieveUpdateDestroyAPIView)
for clean, reusable endpoint logic.
"""
from rest_framework import generics
from .models import Task
from .serializers import TaskSerializer


class TaskListCreateView(generics.ListCreateAPIView):
    """
    GET /api/tasks/ - List all tasks (ordered by newest first).
    POST /api/tasks/ - Create a new task.
    """
    queryset = Task.objects.all()
    serializer_class = TaskSerializer


class TaskDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET /api/tasks/<uuid:pk>/ - Retrieve a single task.
    PATCH /api/tasks/<uuid:pk>/ - Partial update (e.g., toggle is_completed).
    DELETE /api/tasks/<uuid:pk>/ - Delete a task.
    """
    queryset = Task.objects.all()
    serializer_class = TaskSerializer
