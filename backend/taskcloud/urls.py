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
        """Adjust schema URL to include any path prefix used by the reverse proxy.

        When the app is hosted under a sub-path (e.g., "/tasks"), the default
        absolute schema URL ("/api/schema/") used by the Swagger UI won't include
        that prefix, causing the browser to request the wrong URL.

        We derive the prefix directly from the current request path by stripping
        the trailing route ("/api/docs/") and preprend it to the schema URL.
        This keeps local/dev (no prefix) and production (with prefix) working
        without additional environment variables or proxy header tweaks.
        """
        path = request.path
        prefix = ''
        if path.endswith('/api/docs/'):
            prefix = path[:-len('/api/docs/')]
        # Ensure leading slash is present (it will be for request.path)
        schema_path = f"{prefix}/api/schema/"
        # Override the URL used by the embedded UI
        self.url = schema_path
        return super().get(request, *args, **kwargs)


class ThrottledRedocView(SpectacularRedocView):
    """ReDoc view with scoped throttling to reduce abuse."""
    throttle_scope = 'docs'
    
    def get(self, request, *args, **kwargs):
        """Same dynamic prefixing logic as ThrottledSwaggerView."""
        path = request.path
        prefix = ''
        if path.endswith('/api/redoc/'):
            prefix = path[:-len('/api/redoc/')]
        schema_path = f"{prefix}/api/schema/"
        self.url = schema_path
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
