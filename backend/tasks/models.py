"""
Task model for To-Do List application.

Follows best practices:
- UUID primary key for distributed systems and security.
- Auto-managed timestamps (created_at).
- Optional due_date for task deadlines.
- Server will auto-delete tasks ~60 min after creation (managed separately).
"""
import uuid
from django.db import models


class Task(models.Model):
    """
    Represents a single task in the To-Do list.

    Attributes:
        id: UUID primary key.
        title: Short description of the task (max 200 chars).
        description: Optional longer text.
        created_at: Timestamp when task was created (auto).
        due_date: Optional deadline for the task.
        is_completed: Boolean completion status.
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    due_date = models.DateTimeField(null=True, blank=True)
    is_completed = models.BooleanField(default=False)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['-created_at']),
        ]

    def __str__(self):
        return self.title
