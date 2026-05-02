from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from datetime import date

from .models import PrayerTime, PrayerLog, QiblaData
from .serializers import PrayerTimeSerializer, PrayerLogSerializer, QiblaSerializer
from .services import fetch_prayer_times, fetch_qibla_direction


class PrayerTimesView(APIView):
    """GET /api/prayer/times/ — return today's prayer times, fetch + cache if needed."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user        = request.user
        today       = date.today()
        city        = request.query_params.get('city', 'Lahore')
        country     = request.query_params.get('country', 'Pakistan')
        method      = int(request.query_params.get('method', 1))  # Karachi method

        # Check cache first
        prayer_time = PrayerTime.objects.filter(user=user, date=today).first()

        if not prayer_time:
            try:
                timings = fetch_prayer_times(city, country, method, today)
            except RuntimeError as e:
                return Response({'error': str(e)}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

            prayer_time = PrayerTime.objects.create(
                user    = user,
                date    = today,
                city    = city,
                country = country,
                method  = method,
                **timings,
            )

        serializer = PrayerTimeSerializer(prayer_time)
        return Response(serializer.data)


class QiblaView(APIView):
    """GET /api/prayer/qibla/?lat=31.5&lng=74.3 — encrypted GPS stored, direction returned."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        lat_str = request.query_params.get('lat')
        lng_str = request.query_params.get('lng')

        if not lat_str or not lng_str:
            return Response(
                {'error': 'lat and lng query parameters are required.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            lat = float(lat_str)
            lng = float(lng_str)
        except ValueError:
            return Response({'error': 'lat and lng must be numeric.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            direction = fetch_qibla_direction(lat, lng)
        except RuntimeError as e:
            return Response({'error': str(e)}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

        # Store encrypted GPS + direction
        qibla = QiblaData.objects.create(
            user      = request.user,
            latitude  = lat,
            longitude = lng,
            direction = direction,
        )

        serializer = QiblaSerializer(qibla)
        return Response(serializer.data)


class PrayerLogView(APIView):
    """POST /api/prayer/log/ — mark a prayer as completed."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = PrayerLogSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        prayer_name = serializer.validated_data['prayer_name']
        log_date    = serializer.validated_data.get('date', date.today())

        # Upsert — update if already logged today
        log, created = PrayerLog.objects.update_or_create(
            user        = request.user,
            date        = log_date,
            prayer_name = prayer_name,
            defaults    = {'completed': True},
        )

        return Response(
            PrayerLogSerializer(log).data,
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK,
        )


class PrayerHistoryView(APIView):
    """GET /api/prayer/history/?days=7 — last N days of prayer logs."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        days = int(request.query_params.get('days', 7))
        logs = PrayerLog.objects.filter(user=request.user).order_by('-date', 'prayer_name')[:days * 5]
        serializer = PrayerLogSerializer(logs, many=True)
        return Response(serializer.data)