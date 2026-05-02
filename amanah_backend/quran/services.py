import requests
from django.core.cache import cache

ALQURAN_BASE = "https://api.alquran.cloud/v1"
AUDIO_BASE = "https://cdn.islamic.network/quran/audio/128/ar.alafasy"

def get_all_surahs():
    cache_key = "quran_surah_list"
    cached = cache.get(cache_key)
    if cached:
        return cached

    resp = requests.get(f"{ALQURAN_BASE}/surah", timeout=10)
    resp.raise_for_status()
    data = resp.json().get("data", [])

    result = [
        {
            "number": s["number"],
            "name": s["name"],
            "englishName": s["englishName"],
            "englishNameTranslation": s["englishNameTranslation"],
            "numberOfAyahs": s["numberOfAyahs"],
            "revelationType": s["revelationType"],
        }
        for s in data
    ]

    cache.set(cache_key, result, timeout=86400)  # cache 24h
    return result


def get_surah_detail(surah_number):
    cache_key = f"quran_surah_{surah_number}"
    cached = cache.get(cache_key)
    if cached:
        return cached

    # Fetch Arabic + English translation together
    arabic_resp = requests.get(f"{ALQURAN_BASE}/surah/{surah_number}", timeout=10)
    english_resp = requests.get(f"{ALQURAN_BASE}/surah/{surah_number}/en.asad", timeout=10)
    arabic_resp.raise_for_status()
    english_resp.raise_for_status()

    arabic_data = arabic_resp.json()["data"]
    english_data = english_resp.json()["data"]

    ayahs = []
    for ar, en in zip(arabic_data["ayahs"], english_data["ayahs"]):
        ayahs.append({
            "number": ar["numberInSurah"],
            "arabic": ar["text"],
            "translation": en["text"],
            "audioUrl": f"{AUDIO_BASE}/{ar['number']}.mp3",
        })

    result = {
        "number": arabic_data["number"],
        "name": arabic_data["name"],
        "englishName": arabic_data["englishName"],
        "englishNameTranslation": arabic_data["englishNameTranslation"],
        "numberOfAyahs": arabic_data["numberOfAyahs"],
        "revelationType": arabic_data["revelationType"],
        "ayahs": ayahs,
    }

    cache.set(cache_key, result, timeout=86400)
    return result


def search_quran(query):
    """Search in both Arabic and English translation."""
    resp = requests.get(
        f"{ALQURAN_BASE}/search/{query}/all/en.asad",
        timeout=10
    )
    resp.raise_for_status()
    matches = resp.json().get("data", {}).get("matches", [])

    results = []
    for m in matches:
        results.append({
            "surahNumber": m["surah"]["number"],
            "surahName": m["surah"]["englishName"],
            "ayahNumber": m["numberInSurah"],
            "text": m["text"],
            "audioUrl": f"{AUDIO_BASE}/{m['number']}.mp3",
        })
    return results