from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone
from prayer.models import PrayerLog
from growth.models import MoodEntry, GoalCompletion, Goal
from growth.services import calculate_amanah_score


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def batch_sync(request):
    """
    FR29 — Accept a list of offline-queued actions and apply them server-side.
    POST /api/sync/batch/
    """
    actions = request.data.get("actions", [])
    if not isinstance(actions, list):
        return Response({"error": "actions must be a list"}, status=status.HTTP_400_BAD_REQUEST)

    results = []
    user = request.user

    for action in actions:
        action_type = action.get("type")
        logged_at_str = action.get("logged_at")

        try:
            logged_at = timezone.datetime.fromisoformat(logged_at_str) if logged_at_str else timezone.now()
        except ValueError:
            logged_at = timezone.now()

        if action_type == "prayer_log":
            prayer_name = action.get("prayer_name", "")
            VALID_PRAYERS = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
            if prayer_name not in VALID_PRAYERS:
                results.append({"type": action_type, "status": "error", "detail": f"Invalid prayer: {prayer_name}"})
                continue

            PrayerLog.objects.get_or_create(
                user=user,
                prayer_name=prayer_name,
                date=logged_at.date(),
            )
            results.append({"type": action_type, "status": "ok", "prayer": prayer_name, "date": str(logged_at.date())})

        elif action_type == "mood_log":
            mood = action.get("emotion", "")  # accept "emotion" key from Flutter
            note = action.get("note", "")
            VALID_MOODS = [
                "happy", "sad", "anxious", "calm", "grateful", "angry",
                "hopeful", "depressed", "lonely", "overwhelmed", "content",
                "frustrated", "excited", "melancholic", "at_peace"
            ]
            if mood not in VALID_MOODS:
                results.append({"type": action_type, "status": "error", "detail": f"Invalid mood: {mood}"})
                continue

            # logged_at is auto_now_add so we can't set it — just create the entry
            MoodEntry.objects.create(user=user, mood=mood, note=note)
            results.append({"type": action_type, "status": "ok", "mood": mood})

        elif action_type == "goal_complete":
            goal_id = action.get("goal_id")
            try:
                goal = Goal.objects.get(id=goal_id, user=user, is_active=True)
                GoalCompletion.objects.get_or_create(
                    goal=goal,
                    completed_on=logged_at.date()  # correct field name
                )
                results.append({"type": action_type, "status": "ok", "goal_id": goal_id})
            except Goal.DoesNotExist:
                results.append({"type": action_type, "status": "error", "detail": f"Goal {goal_id} not found"})

        else:
            results.append({"type": action_type, "status": "error", "detail": "Unknown action type"})

    calculate_amanah_score(user)

    return Response({
        "synced": len([r for r in results if r["status"] == "ok"]),
        "failed": len([r for r in results if r["status"] == "error"]),
        "results": results,
    }, status=status.HTTP_200_OK)