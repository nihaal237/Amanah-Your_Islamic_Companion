from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404

from .models import Question, Answer
from .serializers import (
    QuestionSerializer,
    AskQuestionSerializer,
    SubmitAnswerSerializer,
)


class IsUser(IsAuthenticated):
    """Allow only users with is_user=True."""
    def has_permission(self, request, view):
        return super().has_permission(request, view) and request.user.is_user


class IsScholar(IsAuthenticated):
    """Allow only users with is_scholar=True."""
    def has_permission(self, request, view):
        return super().has_permission(request, view) and request.user.is_scholar


# POST /api/scholar/ask/
class AskQuestionView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        if not request.user.is_user:
            return Response(
                {'error': 'Only regular users can ask questions.'},
                status=status.HTTP_403_FORBIDDEN
            )

        # One-question rule (FR23): reject if user already has a pending question
        has_pending = Question.objects.filter(
            user=request.user, status='pending'
        ).exists()
        if has_pending:
            return Response(
                {'error': 'You already have a pending question. Wait for it to be answered before asking another.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        serializer = AskQuestionSerializer(data=request.data)
        if serializer.is_valid():
            question = serializer.save(user=request.user)
            return Response(QuestionSerializer(question).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# GET /api/scholar/questions/
class PendingQuestionsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if not request.user.is_scholar:
            return Response(
                {'error': 'Only scholars can view pending questions.'},
                status=status.HTTP_403_FORBIDDEN
            )

        questions = Question.objects.filter(status='pending').select_related('user')
        serializer = QuestionSerializer(questions, many=True)
        return Response(serializer.data)


# POST /api/scholar/answer/<question_id>/
class SubmitAnswerView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, question_id):
        if not request.user.is_scholar:
            return Response(
                {'error': 'Only scholars can answer questions.'},
                status=status.HTTP_403_FORBIDDEN
            )

        question = get_object_or_404(Question, id=question_id, status='pending')

        # Prevent duplicate answers
        if hasattr(question, 'answer'):
            return Response(
                {'error': 'This question has already been answered.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        serializer = SubmitAnswerSerializer(data=request.data)
        if serializer.is_valid():
            Answer.objects.create(
                question=question,
                scholar=request.user,
                text=serializer.validated_data['text']
            )
            question.status = 'answered'
            question.save()
            return Response(QuestionSerializer(question).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# GET /api/scholar/my-questions/
class MyQuestionsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if not request.user.is_user:
            return Response(
                {'error': 'Only regular users can view their questions.'},
                status=status.HTTP_403_FORBIDDEN
            )

        questions = Question.objects.filter(user=request.user).select_related('answer__scholar')
        serializer = QuestionSerializer(questions, many=True)
        return Response(serializer.data)


# GET /api/scholar/archive/
class ArchiveView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # All answered questions are public to authenticated users (FR25)
        questions = Question.objects.filter(
            status='answered'
        ).select_related('user', 'answer__scholar')
        serializer = QuestionSerializer(questions, many=True)
        return Response(serializer.data)