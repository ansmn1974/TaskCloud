"""
Health check view for reverse proxy monitoring.
"""
from django.http import JsonResponse
from django.views.decorators.http import require_GET
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
@require_GET
def health_check(request):
    """
    Simple health check endpoint for Caddy/load balancer monitoring.
    
    Returns:
        200 OK with status=healthy
    """
    return JsonResponse({'status': 'healthy'}, status=200)
