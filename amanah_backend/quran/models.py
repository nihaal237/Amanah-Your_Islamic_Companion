from django.db import models
from django.conf import settings

class QuranBookmark(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='quran_bookmarks'
    )
    surah_number = models.PositiveIntegerField()
    ayah_number = models.PositiveIntegerField()
    surah_name = models.CharField(max_length=100, blank=True)
    ayah_text = models.TextField(blank=True)
    note = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'surah_number', 'ayah_number')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.email} — Surah {self.surah_number}:{self.ayah_number}"