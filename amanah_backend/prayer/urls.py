from django.urls import path
from .views import PrayerTimesView, QiblaView, PrayerLogView, PrayerHistoryView

urlpatterns = [
    path('times/',   PrayerTimesView.as_view(),  name='prayer-times'),
    path('qibla/',   QiblaView.as_view(),         name='prayer-qibla'),
    path('log/',     PrayerLogView.as_view(),      name='prayer-log'),
    path('history/', PrayerHistoryView.as_view(),  name='prayer-history'),
]