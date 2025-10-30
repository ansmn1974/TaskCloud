"""
Model tests for Task.

Following TDD RED phase: these tests are written BEFORE implementation.
They define expected behavior for the Task model.
"""
import pytest
from django.utils import timezone
from tasks.models import Task


@pytest.mark.django_db
class TestTaskModel:
    """Test suite for Task model behavior."""

    def test_task_creation_with_required_fields(self):
        """
        Test that a Task can be created with only required fields (title).
        
        Expected:
        - Task should save successfully
        - Default values should be applied (is_completed=False, description='')
        - UUID id should be auto-generated
        - created_at should be auto-set
        """
        task = Task.objects.create(title="Test Task")
        
        assert task.id is not None
        assert task.title == "Test Task"
        assert task.description == ""
        assert task.is_completed is False
        assert task.created_at is not None
        assert task.due_date is None

    def test_task_creation_with_all_fields(self):
        """
        Test Task creation with all optional fields provided.
        
        Expected:
        - All fields should be saved correctly
        - Optional fields should retain their values
        """
        due_date = timezone.now() + timezone.timedelta(days=7)
        task = Task.objects.create(
            title="Complete Task",
            description="This is a detailed description",
            due_date=due_date,
            is_completed=True,
        )
        
        assert task.title == "Complete Task"
        assert task.description == "This is a detailed description"
        assert task.due_date == due_date
        assert task.is_completed is True

    def test_task_ordering(self):
        """
        Test that tasks are ordered by newest first (Meta.ordering).
        
        Expected:
        - Most recently created task should appear first in queryset
        """
        task1 = Task.objects.create(title="First Task")
        task2 = Task.objects.create(title="Second Task")
        
        tasks = list(Task.objects.all())
        assert tasks[0].id == task2.id
        assert tasks[1].id == task1.id

    def test_task_str_representation(self):
        """
        Test Task __str__ method returns title.
        
        Expected:
        - String representation should be the task title
        """
        task = Task.objects.create(title="My Task Title")
        assert str(task) == "My Task Title"

    def test_task_title_max_length(self):
        """
        Test that title field enforces max_length=200.
        
        Expected:
        - Title longer than 200 chars should raise validation error
        """
        long_title = "x" * 201
        task = Task(title=long_title)
        
        with pytest.raises(Exception):  # Django ValidationError or DataError
            task.full_clean()

    def test_task_completion_toggle(self):
        """
        Test toggling task completion status.
        
        Expected:
        - is_completed should update correctly
        """
        task = Task.objects.create(title="Toggle Task")
        assert task.is_completed is False
        
        task.is_completed = True
        task.save()
        task.refresh_from_db()
        
        assert task.is_completed is True
