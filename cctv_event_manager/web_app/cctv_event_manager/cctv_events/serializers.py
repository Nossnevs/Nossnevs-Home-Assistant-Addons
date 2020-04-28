from django.conf import settings
from rest_framework import serializers
from cctv_events.models import Event, Image


class ImagesSerializer(serializers.ModelSerializer):
    image_file_url = serializers.SerializerMethodField()

    class Meta:
        model = Image
        exclude = ['image_file']
        depth = 0

    @staticmethod
    def get_image_file_url(obj):
        return f"{settings.EXTERNAL_BASE_URL}{obj.image_file.url}".replace("//", "/")


class EventSerializer(serializers.ModelSerializer):
    images = ImagesSerializer(
         many=True,
         read_only=True
    )

    class Meta:
        model = Event
        fields = ['id', 'url', 'creation_date', 'dir_name', 'preview', 'images']
        depth = 1
