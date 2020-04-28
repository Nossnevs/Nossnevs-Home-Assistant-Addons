import os
import shutil

from django.conf import settings
from django.conf.global_settings import MEDIA_ROOT
from django.db import models
# Create your models here.
from django.http import HttpResponseBadRequest
from django.utils import timezone


class Event(models.Model):
    preview = models.ForeignKey('Image', blank=True, null=True, related_name='preview_image_set',
                                on_delete=models.SET_NULL)
    creation_date = models.DateTimeField(auto_now_add=True)
    dir_name = models.CharField(max_length=256, unique=True)
    deleted_at = models.DateTimeField(null=True)

    def delete(self, using=None, keep_parents=False):
        path = os.path.join(settings.MEDIA_ROOT, self.dir_name)
        if not (self.dir_name and settings.MEDIA_ROOT and path != "/" and path != settings.MEDIA_ROOT):
            raise HttpResponseBadRequest
        shutil.rmtree(os.path.join(settings.MEDIA_ROOT, self.dir_name))
        self.deleted_at = timezone.now()
        self.save()


def get_upload_to(instance, filename):
    return os.path.join(MEDIA_ROOT, instance.event.dir_name, filename)


class Image(models.Model):
    event = models.ForeignKey(Event, related_name='images', on_delete=models.CASCADE)
    image_file = models.FileField(upload_to=get_upload_to, unique=True)
    creation_date = models.DateTimeField(auto_now_add=True)
