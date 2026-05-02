"""
Service layer for external API calls.
  - Aladhan API  (prayer times + Qibla direction)
No API key required.
"""
import requests
from datetime import date


ALADHAN_BASE = "https://api.aladhan.com/v1"


def fetch_prayer_times(city: str, country: str, method: int, target_date: date) -> dict:
    """
    Fetch prayer times from Aladhan for a given city/date.
    Returns a dict with prayer time strings or raises RuntimeError.
    """
    date_str = target_date.strftime("%d-%m-%Y")
    url = f"{ALADHAN_BASE}/timingsByCity/{date_str}"
    params = {
        "city":    city,
        "country": country,
        "method":  method,
    }
    resp = requests.get(url, params=params, timeout=10)
    if resp.status_code != 200:
        raise RuntimeError(f"Aladhan API error: {resp.status_code}")

    data   = resp.json()
    timings = data["data"]["timings"]
    return {
        "fajr":    timings["Fajr"],
        "sunrise": timings["Sunrise"],
        "dhuhr":   timings["Dhuhr"],
        "asr":     timings["Asr"],
        "maghrib": timings["Maghrib"],
        "isha":    timings["Isha"],
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