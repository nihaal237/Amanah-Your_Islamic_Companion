from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .services import get_hijri_date, get_upcoming_events


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def hijri_date(request):
    """
    FR26 — Return today's Hijri date.
    GET /api/calendar/hijri/
    """
    try:
        hijri = get_hijri_date()
        return Response(hijri, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_503_SERVICE_UNAVAILABLE)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def islamic_events(request):
    """
    FR27 — Return upcoming Islamic events sorted by proximity.
    GET /api/calendar/events/
    """
    try:
        hijri_today = get_hijri_date()
        events = get_upcoming_events(hijri_today)
        return Response({
            "today_hijri": hijri_today["readable"],
            "events": events
        }, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_503_SERVICE_UNAVAILABLE)