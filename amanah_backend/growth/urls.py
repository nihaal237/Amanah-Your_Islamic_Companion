from django.urls import path
from .views import MoodView, GoalListCreateView, GoalDetailView, AmanahScoreView

urlpatterns = [
    path('mood/', MoodView.as_view(), name='mood'),
    path('goals/', GoalListCreateView.as_view(), name='goals'),
    path('goals/<int:goal_id>/complete/', GoalDetailView.as_view(), name='goal-complete'),
    path('goals/<int:goal_id>/', GoalDetailView.as_view(), name='goal-delete'),
    path('score/', AmanahScoreView.as_view(), name='amanah-score'),
]