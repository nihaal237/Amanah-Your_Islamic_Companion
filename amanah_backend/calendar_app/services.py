import requests
from datetime import date

ISLAMIC_EVENTS = [
    {"name": "Islamic New Year",   "hijri_month": 1,  "hijri_day": 1},
    {"name": "Ashura",             "hijri_month": 1,  "hijri_day": 10},
    {"name": "Mawlid al-Nabi",     "hijri_month": 3,  "hijri_day": 12},
    {"name": "Laylat al-Qadr",     "hijri_month": 9,  "hijri_day": 27},
    {"name": "Ramadan begins",     "hijri_month": 9,  "hijri_day": 1},
    {"name": "Eid ul-Fitr",        "hijri_month": 10, "hijri_day": 1},
    {"name": "Eid ul-Adha",        "hijri_month": 12, "hijri_day": 10},
]

def get_hijri_date(gregorian_date=None):
    """
    Convert a Gregorian date to Hijri using Aladhan API.
    Returns a dict with day, month, year, and readable string.
    """
    if gregorian_date is None:
        gregorian_date = date.today()

    dd = gregorian_date.strftime("%d")
    mm = gregorian_date.strftime("%m")
    yyyy = gregorian_date.strftime("%Y")

    url = f"http://api.aladhan.com/v1/gToH/{dd}-{mm}-{yyyy}"
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        data = response.json()
        hijri = data["data"]["hijri"]
        return {
            "day": int(hijri["day"]),
            "month": int(hijri["month"]["number"]),
            "month_name_en": hijri["month"]["en"],
            "month_name_ar": hijri["month"]["ar"],
            "year": int(hijri["year"]),
            "readable": f"{hijri['day']} {hijri['month']['en']} {hijri['year']} AH",
            "weekday": hijri["weekday"]["en"],
        }
    except Exception as e:
        raise Exception(f"Failed to fetch Hijri date: {str(e)}")


def get_upcoming_events(hijri_today):
    """
    Given today's Hijri date dict, return upcoming Islamic events
    sorted by how soon they occur (within the next 12 months).
    """
    today_month = hijri_today["month"]
    today_day = hijri_today["day"]
    today_year = hijri_today["year"]

    upcoming = []
    for event in ISLAMIC_EVENTS:
        em = event["hijri_month"]
        ed = event["hijri_day"]

        # Days remaining in the Hijri year (approximate)
        # Calculate offset in months/days from today
        if (em, ed) >= (today_month, today_day):
            months_away = (em - today_month)
            event_year = today_year
        else:
            months_away = (12 - today_month) + em
            event_year = today_year + 1

        upcoming.append({
            "name": event["name"],
            "hijri_day": ed,
            "hijri_month": em,
            "hijri_year": event_year,
            "hijri_date_readable": f"{ed} {_month_name(em)} {event_year} AH",
            "months_away": months_away,
        })

    upcoming.sort(key=lambda x: (x["months_away"], x["hijri_day"]))
    return upcoming


def _month_name(month_number):
    names = [
        "", "Muharram", "Safar", "Rabi al-Awwal", "Rabi al-Thani",
        "Jumada al-Awwal", "Jumada al-Thani", "Rajab", "Sha'ban",
        "Ramadan", "Shawwal", "Dhul Qi'dah", "Dhul Hijjah"
    ]
    return names[month_number] if 1 <= month_number <= 12 else ""