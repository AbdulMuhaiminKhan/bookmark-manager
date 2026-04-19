from django.views.generic import ListView, CreateView
from django.urls import reverse_lazy
from django.core.cache import cache
from django.http import JsonResponse
from django.db import connection
from .models import Bookmark


def health_check(request):
    """
    Health check endpoint for monitoring and load balancers.
    Tests database and cache connectivity.
    
    Returns:
        - 200: All systems operational
        - 503: One or more services unavailable
    """
    health_status = {
        'status': 'healthy',
        'services': {}
    }
    http_status = 200
    
    # Test database
    try:
        connection.ensure_connection()
        health_status['services']['database'] = 'ok'
    except Exception as e:
        health_status['services']['database'] = f'error: {str(e)}'
        health_status['status'] = 'unhealthy'
        http_status = 503
    
    # Test cache (Redis)
    try:
        cache.set('health_check', 'ok', 10)
        cached = cache.get('health_check')
        if cached == 'ok':
            health_status['services']['cache'] = 'ok'
        else:
            health_status['services']['cache'] = 'error: cache get failed'
            health_status['status'] = 'unhealthy'
            http_status = 503
    except Exception as e:
        health_status['services']['cache'] = f'error: {str(e)}'
        health_status['status'] = 'unhealthy'
        http_status = 503
    
    # Test bookmark model
    try:
        Bookmark.objects.count()
        health_status['services']['bookmarks'] = 'ok'
    except Exception as e:
        health_status['services']['bookmarks'] = f'error: {str(e)}'
        health_status['status'] = 'unhealthy'
        http_status = 503
    
    return JsonResponse(health_status, status=http_status)


def ready(request):
    """
    Kubernetes readiness probe.
    Returns 200 if ready to accept traffic.
    """
    try:
        connection.ensure_connection()
        return JsonResponse({'ready': True})
    except Exception:
        return JsonResponse({'ready': False}, status=503)


def live(request):
    """
    Kubernetes liveness probe.
    Returns 200 if container is alive (not deadlocked).
    """
    return JsonResponse({'alive': True})


class BookmarkListView(ListView):
    model = Bookmark
    template_name = 'core/bookmark_list.html'
    context_object_name = 'bookmarks'

    def get_queryset(self):
        # Try to get cached bookmarks
        cached = cache.get('all_bookmarks')
        if cached is not None:
            return cached
        qs = Bookmark.objects.all().order_by('-created_at')
        cache.set('all_bookmarks', qs, timeout=60)  # Cache for 60 seconds
        return qs


class BookmarkCreateView(CreateView):
    model = Bookmark
    fields = ['url', 'title']
    template_name = 'core/bookmark_form.html'
    success_url = reverse_lazy('bookmark-list')

    def form_valid(self, form):
        # Clear cache when adding new bookmark
        cache.delete('all_bookmarks')
        return super().form_valid(form)
