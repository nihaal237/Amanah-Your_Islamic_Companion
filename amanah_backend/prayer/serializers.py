from rest_framework import serializers
from .models import PrayerTime, PrayerLog, QiblaData


class PrayerTimeSerializer(serializers.ModelSerializer):
    class Meta:
        model  = PrayerTime
        fields = ['id', 'date', 'city', 'country', 'method',
                  'fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha', 'fetched_at']


class PrayerLogSerializer(serializers.ModelSerializer):
    class Meta:
        model  = PrayerLog
        fields = ['id', 'date', 'prayer_name', 'completed', 'logged_at']
        read_only_fields = ['logged_at']

    def validate_prayer_name(self, value):
        valid = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']
        if value not in valid:
            raise serializers.ValidationError(f"prayer_name must be one of {valid}")
        return value


class QiblaSerializer(serializers.ModelSerializer):
    class Meta:
        model  = QiblaData
        fields = ['id', 'direction', 'fetched_at']
        # latitude/longitude intentionally omitted from response (privacy)