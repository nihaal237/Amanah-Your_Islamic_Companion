from django.contrib import admin
from .models import PrayerTime, PrayerLog, QiblaData

@admin.register(PrayerTime)
class PrayerTimeAdmin(admin.ModelAdmin):
    list_display  = ['user', 'date', 'city', 'fajr', 'dhuhr', 'asr', 'maghrib', 'isha']
    list_filter   = ['date', 'city']
    search_fields = ['user__username', 'city']

@admin.register(PrayerLog)
class PrayerLogAdmin(admin.ModelAdmin):
    list_display  = ['user', 'date', 'prayer_name', 'completed', 'logged_at']
    list_filter   = ['prayer_name', 'completed', 'date']
    search_fields = ['user__username']

@admin.register(QiblaData)
class QiblaDataAdmin(admin.ModelAdmin):
    list_display  = ['user', 'direction', 'fetched_at']
    search_fields = ['user__username']