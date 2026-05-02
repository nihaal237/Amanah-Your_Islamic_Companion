from django.db import models
from django.conf import settings


class MoodEntry(models.Model):
    MOOD_CHOICES = [
        ('happy', 'Happy'),
        ('sad', 'Sad'),
        ('anxious', 'Anxious'),
        ('calm', 'Calm'),
        ('grateful', 'Grateful'),
        ('angry', 'Angry'),
        ('hopeful', 'Hopeful'),
        ('depressed', 'Depressed'),
        ('lonely', 'Lonely'),
        ('overwhelmed', 'Overwhelmed'),
        ('content', 'Content'),
        ('frustrated', 'Frustrated'),
        ('excited', 'Excited'),
        ('melancholic', 'Melancholic'),
        ('at_peace', 'At Peace'),
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='mood_entries'
    )
    mood = models.CharField(max_length=20, choices=MOOD_CHOICES)
    note = models.TextField(blank=True)  # optional reflection
    logged_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-logged_at']

    def __str__(self):
        return f"{self.user.email} — {self.mood} ({self.logged_at.date()})"


class Goal(models.Model):
    FREQUENCY_CHOICES = [
        ('daily', 'Daily'),
        ('weekly', 'Weekly'),
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='goals'
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    frequency = models.CharField(max_length=10, choices=FREQUENCY_CHOICES, default='daily')
    is_active = models.BooleanField(default=True)
    streak = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.email} — {self.title}"


class GoalCompletion(models.Model):
    goal = models.ForeignKey(
        Goal,
        on_delete=models.CASCADE,
        related_name='completions'
    )
    completed_on = models.DateField()  # date of completion (no time)

    class Meta:
        unique_together = ['goal', 'completed_on']  # one completion per day per goal
        ordering = ['-completed_on']

    def __str__(self):
        return f"{self.goal.title} — {self.completed_on}"