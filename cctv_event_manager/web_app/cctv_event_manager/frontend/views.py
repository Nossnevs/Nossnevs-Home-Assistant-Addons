from django.conf import settings
from django.shortcuts import render


def index(request):
    return render(request, 'frontend/index.html', {"EXTERNAL_BASE_URL": settings.EXTERNAL_BASE_URL})
