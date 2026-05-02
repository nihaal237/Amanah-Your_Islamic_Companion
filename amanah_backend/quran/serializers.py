from rest_framework import serializers
from .models import QuranBookmark

class QuranBookmarkSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuranBookmark
        fields = ['id', 'surah_number', 'ayah_number', 'surah_name', 'ayah_text', 'note', 'created_at']
        read_only_fields = ['id', 'created_at']