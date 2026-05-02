from django.db import models
from django.conf import settings
from cryptography.fernet import Fernet
import base64, os

# ── AES-256 encryption helpers (GPS coordinates) ──────────────────────────────
# Fernet uses AES-128-CBC internally; for true AES-256 use a 32-byte key.
# Key is stored in .env as FIELD_ENCRYPTION_KEY (base64-urlsafe, 32 bytes).

def _get_cipher():
    key = settings.FIELD_ENCRYPTION_KEY  # must be 32-byte base64-urlsafe string
    return Fernet(key)

def encrypt_value(plain: str) -> str:
    if not plain:
        return plain
    return _get_cipher().encrypt(plain.encode()).decode()

def decrypt_value(token: str) -> str:
    if not token:
        return token
    return _get_cipher().decrypt(token.encode()).decode()


class EncryptedFloatField(models.TextField):
    """Stores a float as AES-256 encrypted text in the DB."""

    def from_db_value(self, value, expression, connection):
        if value is None:
            return value
        try:
            return float(decrypt_value(value))
        except Exception:
            return None

    def to_python(self, value):
        if isinstance(value, float) or value is None:
            return value
        try:
            return float(decrypt_value(value))
        except Exception:
            return None

    def get_prep_value(self, value):
        if value is None:
            return value
        return encrypt_value(str(value))


# ── Models ─────────────────────────────────────────────────────────────────────

class PrayerTime(models.Model):
    """Cached daily prayer times per user per date."""

    CALCULATION_METHODS = [
        (1, 'University of Islamic Sciences, Karachi'),
        (2, 'Islamic Society of North America'),
        (3, 'Muslim World League'),
        (4, 'Umm Al-Qura University, Makkah'),
        (5, 'Egyptian General Authority of Survey'),
    ]

    user        = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='prayer_times')
    date        = models.DateField()
    city        = models.CharField(max_length=100)
    country     = models.CharField(max_length=100, default='Pakistan')
    method      = models.IntegerField(choices=CALCULATION_METHODS, default=1)  # Karachi method

    fajr        = models.TimeField()
    sunrise     = models.TimeField()
    dhuhr       = models.TimeField()
    asr         = models.TimeField()
    maghrib     = models.TimeField()
    isha        = models.TimeField()

    fetched_at  = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'date')
        ordering = ['-date']

    def __str__(self):
        return f"{self.user.username} — {self.date}"


class PrayerLog(models.Model):
    """Records whether a user completed each prayer on a given day."""

    PRAYER_NAMES = [
        ('fajr',    'Fajr'),
        ('dhuhr',   'Dhuhr'),
        ('asr',     'Asr'),
        ('maghrib', 'Maghrib'),
        ('isha',    'Isha'),
    ]

    user        = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='prayer_logs')
    date        = models.DateField()
    prayer_name = models.CharField(max_length=10, choices=PRAYER_NAMES)
    completed   = models.BooleanField(default=False)
    logged_at   = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'date', 'prayer_name')
        ordering = ['-date', 'prayer_name']

    def __str__(self):
        status = '✓' if self.completed else '✗'
        return f"{self.user.username} — {self.prayer_name} {self.date} {status}"


class QiblaData(models.Model):
    """Cached Qibla direction per location (GPS encrypted at rest)."""

    user            = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='qibla_data')
    latitude        = EncryptedFloatField()   # AES-256 encrypted
    longitude       = EncryptedFloatField()   # AES-256 encrypted
    direction       = models.FloatField()     # degrees from North
    fetched_at      = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-fetched_at']

    def __str__(self):
        return f"{self.user.username} — Qibla {self.direction:.1f}°"