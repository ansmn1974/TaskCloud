"""
URL configuration for taskcloud project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularSwaggerView,
    SpectacularRedocView,
)
from .health import health_check


class ThrottledSchemaView(SpectacularAPIView):
    """Schema view with scoped throttling to reduce abuse."""
    throttle_scope = 'schema'


class ThrottledSwaggerView(SpectacularSwaggerView):
    """Swagger UI view with scoped throttling to reduce abuse."""
    throttle_scope = 'docs'
    
    def get(self, request, *args, **kwargs):
        """Point the UI to a path-relative schema URL.

        Using a relative path like "../schema/" makes the browser resolve it
        correctly whether the app is mounted at the domain root ("/api/docs/")
        or under a proxy prefix (e.g., "/tasks/api/docs/").
        """
        self.url = '../schema/'
        return super().get(request, *args, **kwargs)


class ThrottledRedocView(SpectacularRedocView):
    """ReDoc view with scoped throttling to reduce abuse."""
    throttle_scope = 'docs'
    
    def get(self, request, *args, **kwargs):
        """Use a path-relative schema URL so reverse proxy prefixes are honored."""
        self.url = '../schema/'
        return super().get(request, *args, **kwargs)

urlpatterns = [
    path('health/', health_check, name='health'),
    path('admin/', admin.site.urls),
    path('api/tasks/', include('tasks.urls')),
    # API documentation (available in production with throttling)
    path('api/schema/', ThrottledSchemaView.as_view(), name='schema'),
    path('api/docs/', ThrottledSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('api/redoc/', ThrottledRedocView.as_view(url_name='schema'), name='redoc'),
]
