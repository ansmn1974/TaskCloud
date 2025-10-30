"""
URL configuration for tasks app.
"""
from django.urls import path
from . import views

app_name = 'tasks'

urlpatterns = [
    path('', views.TaskListCreateView.as_view(), name='task-list-create'),
    path('<uuid:pk>/', views.TaskDetailView.as_view(), name='task-detail'),
]
