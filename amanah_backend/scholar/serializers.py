from rest_framework import serializers
from .models import Question, Answer


class AnswerSerializer(serializers.ModelSerializer):
    scholar_email = serializers.EmailField(source='scholar.email', read_only=True)

    class Meta:
        model = Answer
        fields = ['id', 'text', 'scholar_email', 'created_at']


class QuestionSerializer(serializers.ModelSerializer):
    answer = AnswerSerializer(read_only=True)
    user_email = serializers.EmailField(source='user.email', read_only=True)

    class Meta:
        model = Question
        fields = ['id', 'text', 'status', 'user_email', 'answer', 'created_at', 'updated_at']
        read_only_fields = ['status', 'user_email', 'answer', 'created_at', 'updated_at']


class AskQuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = ['text']


class SubmitAnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['text']