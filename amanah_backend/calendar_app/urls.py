from django.urls import path
from . import views

urlpatterns = [
    path("hijri/", views.hijri_date, name="hijri-date"),
    path("events/", views.islamic_events, name="islamic-events"),
]