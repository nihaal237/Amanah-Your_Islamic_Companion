from django.contrib import admin
from .models import QuranBookmark

@admin.register(QuranBookmark)
class QuranBookmarkAdmin(admin.ModelAdmin):
    list_display = ['user', 'surah_number', 'ayah_number', 'created_at']
    list_filter = ['surah_number']
    search_fields = ['user__email']