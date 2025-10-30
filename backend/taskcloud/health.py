"""
Health check view for reverse proxy monitoring.
"""
from django.http import JsonResponse
from django.views.decorators.http import require_GET


@require_GET
def health_check(request):
    """
    Simple health check endpoint for Caddy/load balancer monitoring.
    
    Returns:
        200 OK with status=healthy
    """
    return JsonResponse({'status': 'healthy'}, status=200)
