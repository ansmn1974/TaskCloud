"""
API endpoint tests for Task CRUD operations.

Following TDD RED phase: these tests define expected API behavior
before full implementation.
"""
import pytest
from django.utils import timezone
from rest_framework.test import APIClient
from rest_framework import status
from tasks.models import Task


@pytest.fixture
def api_client():
    """Provide DRF API client for tests."""
    return APIClient()


@pytest.fixture
def sample_task():
    """Create a sample task for testing."""
    return Task.objects.create(
        title="Sample Task",
        description="Sample description",
    )


@pytest.mark.django_db
class TestTaskListCreateAPI:
    """Test suite for GET /api/tasks/ and POST /api/tasks/"""

    def test_list_empty_tasks(self, api_client):
        """
        Test GET /api/tasks/ returns empty list when no tasks exist.
        
        Expected:
        - Status 200 OK
        - Empty list response
        """
        response = api_client.get('/api/tasks/')
        
        assert response.status_code == status.HTTP_200_OK
        assert response.data == []

    def test_list_tasks(self, api_client, sample_task):
        """
        Test GET /api/tasks/ returns all tasks.
        
        Expected:
        - Status 200 OK
        - List containing task data
        - Task fields match model
        """
        response = api_client.get('/api/tasks/')
        
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 1
        assert response.data[0]['title'] == "Sample Task"
        assert response.data[0]['description'] == "Sample description"
        assert response.data[0]['is_completed'] is False

    def test_create_task_minimal(self, api_client):
        """
        Test POST /api/tasks/ creates task with only required fields.
        
        Expected:
        - Status 201 Created
        - Task created in database
        - Response contains created task data with auto-generated fields
        """
        data = {'title': 'New Task'}
        response = api_client.post('/api/tasks/', data, format='json')
        
        assert response.status_code == status.HTTP_201_CREATED
        assert response.data['title'] == 'New Task'
        assert response.data['is_completed'] is False
        assert 'id' in response.data
        assert 'created_at' in response.data
        
        # Verify in database
        assert Task.objects.filter(title='New Task').exists()

    def test_create_task_full(self, api_client):
        """
        Test POST /api/tasks/ with all fields provided.
        
        Expected:
        - Status 201 Created
        - All fields saved correctly
        """
        due_date = (timezone.now() + timezone.timedelta(days=3)).isoformat()
        data = {
            'title': 'Complete Task',
            'description': 'Detailed description',
            'due_date': due_date,
            'is_completed': True,
        }
        response = api_client.post('/api/tasks/', data, format='json')
        
        assert response.status_code == status.HTTP_201_CREATED
        assert response.data['title'] == 'Complete Task'
        assert response.data['description'] == 'Detailed description'
        assert response.data['is_completed'] is True

    def test_create_task_missing_title(self, api_client):
        """
        Test POST /api/tasks/ without required title field.
        
        Expected:
        - Status 400 Bad Request
        - Error message about missing title
        """
        data = {'description': 'No title provided'}
        response = api_client.post('/api/tasks/', data, format='json')
        
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert 'title' in response.data


@pytest.mark.django_db
class TestTaskDetailAPI:
    """Test suite for GET/PATCH/DELETE /api/tasks/<uuid:pk>/"""

    def test_retrieve_task(self, api_client, sample_task):
        """
        Test GET /api/tasks/<id>/ retrieves single task.
        
        Expected:
        - Status 200 OK
        - Response contains task data
        """
        response = api_client.get(f'/api/tasks/{sample_task.id}/')
        
        assert response.status_code == status.HTTP_200_OK
        assert response.data['id'] == str(sample_task.id)
        assert response.data['title'] == sample_task.title

    def test_retrieve_nonexistent_task(self, api_client):
        """
        Test GET /api/tasks/<invalid-id>/ returns 404.
        
        Expected:
        - Status 404 Not Found
        """
        fake_uuid = '00000000-0000-0000-0000-000000000000'
        response = api_client.get(f'/api/tasks/{fake_uuid}/')
        
        assert response.status_code == status.HTTP_404_NOT_FOUND

    def test_partial_update_task(self, api_client, sample_task):
        """
        Test PATCH /api/tasks/<id>/ updates specific fields.
        
        Expected:
        - Status 200 OK
        - Only specified fields updated
        - Other fields unchanged
        """
        data = {'is_completed': True}
        response = api_client.patch(
            f'/api/tasks/{sample_task.id}/',
            data,
            format='json'
        )
        
        assert response.status_code == status.HTTP_200_OK
        assert response.data['is_completed'] is True
        assert response.data['title'] == sample_task.title  # unchanged
        
        # Verify in database
        sample_task.refresh_from_db()
        assert sample_task.is_completed is True

    def test_full_update_task(self, api_client, sample_task):
        """
        Test PUT /api/tasks/<id>/ replaces entire task (if supported).
        
        Expected:
        - All fields updated
        """
        data = {
            'title': 'Updated Title',
            'description': 'Updated description',
            'is_completed': True,
        }
        response = api_client.put(
            f'/api/tasks/{sample_task.id}/',
            data,
            format='json'
        )
        
        # RetrieveUpdateDestroyAPIView supports PUT
        assert response.status_code in [status.HTTP_200_OK, status.HTTP_405_METHOD_NOT_ALLOWED]
        if response.status_code == status.HTTP_200_OK:
            assert response.data['title'] == 'Updated Title'

    def test_delete_task(self, api_client, sample_task):
        """
        Test DELETE /api/tasks/<id>/ removes task.
        
        Expected:
        - Status 204 No Content
        - Task deleted from database
        """
        task_id = sample_task.id
        response = api_client.delete(f'/api/tasks/{task_id}/')
        
        assert response.status_code == status.HTTP_204_NO_CONTENT
        assert not Task.objects.filter(id=task_id).exists()

    def test_delete_nonexistent_task(self, api_client):
        """
        Test DELETE /api/tasks/<invalid-id>/ returns 404.
        
        Expected:
        - Status 404 Not Found
        """
        fake_uuid = '00000000-0000-0000-0000-000000000000'
        response = api_client.delete(f'/api/tasks/{fake_uuid}/')
        
        assert response.status_code == status.HTTP_404_NOT_FOUND
