"""
DRF serializers for Task model.

Uses ModelSerializer for automatic field serialization and validation.
"""
from rest_framework import serializers
from .models import Task


class TaskSerializer(serializers.ModelSerializer):
    """
    Serializer for Task model with full CRUD support.

    Automatically handles validation, serialization, and deserialization
    using Django REST Framework's ModelSerializer.

    Fields:
        id (UUID): Read-only. Auto-generated unique identifier.
        title (str): Required. Task title (max 200 characters).
        description (str): Optional. Detailed task description.
        created_at (datetime): Read-only. Auto-set timestamp when task is created.
        due_date (datetime): Optional. Deadline for task completion.
        is_completed (bool): Task completion status. Defaults to False.

    Usage:
        # Deserialize and create
        serializer = TaskSerializer(data=request.data)
        if serializer.is_valid():
            task = serializer.save()

        # Serialize for response
        serializer = TaskSerializer(task)
        return Response(serializer.data)
    """

    class Meta:
        model = Task
        fields = [
            'id',
            'title',
            'description',
            'created_at',
            'due_date',
            'is_completed',
        ]
        read_only_fields = ['id', 'created_at']
