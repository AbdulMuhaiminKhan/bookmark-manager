from django.urls import path
from .views import BookmarkListView, BookmarkCreateView, health_check, ready, live

urlpatterns = [
    path('', BookmarkListView.as_view(), name='bookmark-list'),
    path('add/', BookmarkCreateView.as_view(), name='bookmark-add'),
    path('health/', health_check, name='health-check'),
    path('ready/', ready, name='readiness-probe'),
    path('live/', live, name='liveness-probe'),
]
