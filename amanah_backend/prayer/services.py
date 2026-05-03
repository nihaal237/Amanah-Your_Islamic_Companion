"""
Service layer for external API calls.
  - Aladhan API  (prayer times + Qibla direction)
No API key required.
"""
import requests
from datetime import date


ALADHAN_BASE = "https://api.aladhan.com/v1"


from .models import PrayerTime, PrayerLog, QiblaData, CachedPrayerTime
from django.utils import timezone

def get_prayer_times(user, city="Lahore", country="Pakistan", method=1):
    today = timezone.now().date()
    url = f"http://api.aladhan.com/v1/timingsByCity/{today}?city={city}&country={country}&method={method}"

    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        data = response.json()["data"]["timings"]

        # Save/update cache
        CachedPrayerTime.objects.update_or_create(
            user=user, date=today, city=city, country=country,
            defaults={
                "fajr": data["Fajr"],
                "dhuhr": data["Dhuhr"],
                "asr": data["Asr"],
                "maghrib": data["Maghrib"],
                "isha": data["Isha"],
            }
        )

        return {
            "data_source": "live",
            "date": str(today),
            "city": city,
            "country": country,
            "timings": {
                "Fajr": data["Fajr"],
                "Dhuhr": data["Dhuhr"],
                "Asr": data["Asr"],
                "Maghrib": data["Maghrib"],
                "Isha": data["Isha"],
            }
        }

    except Exception:
        # Fallback to cache
        cached = CachedPrayerTime.objects.filter(
            user=user, city=city, country=country
        ).order_by("-date").first()

        if cached:
            return {
                "data_source": "cache",
                "date": str(cached.date),
                "city": city,
                "country": country,
                "timings": {
                    "Fajr": cached.fajr,
                    "Dhuhr": cached.dhuhr,
                    "Asr": cached.asr,
                    "Maghrib": cached.maghrib,
                    "Isha": cached.isha,
                }
            }

        return {
            "data_source": "unavailable",
            "error": "Prayer times unavailable. No internet and no cached data found."
        }


def fetch_qibla_direction(latitude: float, longitude: float) -> float:
    """
    Fetch Qibla direction (degrees from North) for given coordinates.
    Returns float or raises RuntimeError.
    """
    url = f"{ALADHAN_BASE}/qibla/{latitude}/{longitude}"
    resp = requests.get(url, timeout=10)
    if resp.status_code != 200:
        raise RuntimeError(f"Aladhan Qibla API error: {resp.status_code}")

    return resp.json()["data"]["direction"]