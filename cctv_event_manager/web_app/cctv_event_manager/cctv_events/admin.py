from django.contrib import admin

from cctv_events.models import Event, Image


class EventAdmin(admin.ModelAdmin):
    pass


class ImageAdmin(admin.ModelAdmin):
    pass


admin.site.register(Event, EventAdmin)
admin.site.register(Image, ImageAdmin)
