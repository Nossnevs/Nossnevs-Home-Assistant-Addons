from rest_framework import viewsets, mixins
from rest_framework.views import APIView
from django.http import HttpResponse
from django.conf import settings
import glob
import os
from cctv_events.models import Event, Image
from cctv_events.serializers import EventSerializer, ImagesSerializer


class EventViewSet(
    mixins.RetrieveModelMixin,
    mixins.DestroyModelMixin,
    mixins.ListModelMixin,
    viewsets.GenericViewSet
):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = Event.objects.filter(deleted_at__isnull=True).order_by('-creation_date')
    serializer_class = EventSerializer


class ImageViewSet(
    mixins.RetrieveModelMixin,
    mixins.DestroyModelMixin,
    mixins.ListModelMixin,
    viewsets.GenericViewSet
):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = Image.objects.all().order_by('-creation_date')
    serializer_class = ImagesSerializer

class DeleteAllEvents(APIView):
    def get(self, request):
        self.deleteAll()
        return HttpResponse("Done")

    def deleteAll(self):
        allEvents = Event.objects.filter(deleted_at__isnull=True).order_by('-creation_date')
        for event in allEvents:
            event.delete()

class SyncEventFiles(APIView):

    def get(self, request):

        self.create_events()

        return HttpResponse("Done")

    @staticmethod
    def has_images(dir_name):
        image_paths = glob.glob(os.path.join(settings.MEDIA_ROOT, dir_name, '*.jpg'))
        return image_paths == []

    def create_events(self):
        for sub_dir in next(os.walk(settings.MEDIA_ROOT))[1]:
            event_exist = Event.objects.filter(dir_name=sub_dir)
            if event_exist:
                continue
            if self.has_images(sub_dir):
                continue
            event = Event(dir_name=sub_dir)
            event.save()
            preview_image = self.create_images(event)
            event.preview = preview_image
            event.save()

    @staticmethod
    def create_images(event):
        image_paths = glob.glob(os.path.join(settings.MEDIA_ROOT, event.dir_name, '*.jpg'))
        first_image = None
        for image_path in image_paths:
            image_exists = Image.objects.filter(event=event, image_file=image_path).first()
            if image_exists:
                continue
            image = Image(event=event)
            image.image_file.name = image_path.replace(settings.MEDIA_ROOT, '')
            image.save()
            if not first_image:
                first_image = image
        return first_image
