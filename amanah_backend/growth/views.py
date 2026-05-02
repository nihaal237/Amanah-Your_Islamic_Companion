from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.shortcuts import get_object_or_404

from .models import MoodEntry, Goal, GoalCompletion
from .serializers import MoodEntrySerializer, GoalSerializer
from .services import calculate_amanah_score


# POST /api/growth/mood/log/
# GET  /api/growth/mood/history/
class MoodView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = MoodEntrySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request):
        entries = MoodEntry.objects.filter(user=request.user)
        serializer = MoodEntrySerializer(entries, many=True)
        return Response(serializer.data)


# GET  /api/growth/goals/
# POST /api/growth/goals/
class GoalListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        goals = Goal.objects.filter(user=request.user, is_active=True)
        serializer = GoalSerializer(goals, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = GoalSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# POST   /api/growth/goals/<id>/complete/  — mark complete today
# DELETE /api/growth/goals/<id>/           — deactivate goal
class GoalDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, goal_id):
        goal = get_object_or_404(Goal, id=goal_id, user=request.user, is_active=True)
        today = timezone.localdate()

        completion, created = GoalCompletion.objects.get_or_create(
            goal=goal,
            completed_on=today
        )

        if not created:
            return Response(
                {'message': 'Goal already marked complete for today.'},
                status=status.HTTP_200_OK
            )

        # Update streak
        yesterday = today - timezone.timedelta(days=1)
        did_yesterday = GoalCompletion.objects.filter(
            goal=goal, completed_on=yesterday
        ).exists()
        goal.streak = goal.streak + 1 if did_yesterday else 1
        goal.save(update_fields=['streak'])

        # Recalculate Amanah Score
        new_score = calculate_amanah_score(request.user)

        return Response({
            'message': 'Goal completed!',
            'streak': goal.streak,
            'amanah_score': new_score
        }, status=status.HTTP_201_CREATED)

    def delete(self, request, goal_id):
        goal = get_object_or_404(Goal, id=goal_id, user=request.user)
        goal.is_active = False
        goal.save(update_fields=['is_active'])
        return Response({'message': 'Goal removed.'}, status=status.HTTP_200_OK)


# GET /api/growth/score/
class AmanahScoreView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({
            'amanah_score': request.user.amanah_score,
            'email': request.user.email
        })