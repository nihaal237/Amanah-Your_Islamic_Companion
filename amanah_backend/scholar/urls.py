from django.urls import path
from .views import (
    AskQuestionView,
    PendingQuestionsView,
    SubmitAnswerView,
    MyQuestionsView,
    ArchiveView,
)

urlpatterns = [
    path('ask/', AskQuestionView.as_view(), name='scholar-ask'),
    path('questions/', PendingQuestionsView.as_view(), name='scholar-pending'),
    path('answer/<int:question_id>/', SubmitAnswerView.as_view(), name='scholar-answer'),
    path('my-questions/', MyQuestionsView.as_view(), name='scholar-my-questions'),
    path('archive/', ArchiveView.as_view(), name='scholar-archive'),
]