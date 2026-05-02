from rest_framework import serializers
from .models import MoodEntry, Goal, GoalCompletion


class MoodEntrySerializer(serializers.ModelSerializer):
    class Meta:
        model = MoodEntry
        fields = ['id', 'mood', 'note', 'logged_at']
        read_only_fields = ['logged_at']


class GoalCompletionSerializer(serializers.ModelSerializer):
    class Meta:
        model = GoalCompletion
        fields = ['id', 'completed_on']


class GoalSerializer(serializers.ModelSerializer):
    completions = GoalCompletionSerializer(many=True, read_only=True)
    completed_today = serializers.SerializerMethodField()

    class Meta:
        model = Goal
        fields = [
            'id', 'title', 'description', 'frequency',
            'is_active', 'streak', 'created_at',
            'completions', 'completed_today'
        ]
        read_only_fields = ['streak', 'created_at', 'completions', 'completed_today']

    def get_completed_today(self, obj):
        from django.utils import timezone
        today = timezone.localdate()
        return obj.completions.filter(completed_on=today).exists()