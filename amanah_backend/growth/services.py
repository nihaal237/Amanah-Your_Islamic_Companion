from django.utils import timezone
from prayer.models import PrayerLog
from .models import GoalCompletion


# Amanah Score weights
PRAYER_WEIGHT = 5       # per prayer logged today (max 5 prayers = 25 pts)
GOAL_WEIGHT = 10        # per goal completed today (max 5 goals = 50 pts)
QURAN_WEIGHT = 25       # flat bonus if user has any bookmarks (proxy for Quran activity)

MAX_SCORE = 100


def calculate_amanah_score(user):
    """
    Recalculates and saves the user's Amanah Score based on today's activity.
    Called whenever user logs prayer, completes goal, or bookmarks Quran ayah.
    """
    today = timezone.localdate()
    score = 0

    # Prayers logged today
    prayers_today = PrayerLog.objects.filter(user=user, logged_at__date=today).count()
    score += min(prayers_today, 5) * PRAYER_WEIGHT  # cap at 5 prayers

    # Goals completed today
    goals_today = GoalCompletion.objects.filter(
        goal__user=user,
        completed_on=today
    ).count()
    score += min(goals_today, 5) * GOAL_WEIGHT  # cap at 5 goals

    # Quran activity — bookmarks as proxy
    from quran.models import QuranBookmark
    has_quran_activity = QuranBookmark.objects.filter(user=user).exists()
    if has_quran_activity:
        score += QURAN_WEIGHT

    score = min(score, MAX_SCORE)

    user.amanah_score = score
    user.save(update_fields=['amanah_score'])
    return score