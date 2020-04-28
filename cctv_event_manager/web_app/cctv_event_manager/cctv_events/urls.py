from rest_framework import routers
from django.conf.urls import include
from django.urls import path
from cctv_events.views import EventViewSet, SyncEventFiles, ImageViewSet

router = routers.DefaultRouter()
router.register(r'events', EventViewSet)
router.register(r'images', ImageViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('sync/', SyncEventFiles.as_view()),
    path('auth/', include('rest_framework.urls', namespace='rest_framework'))
]