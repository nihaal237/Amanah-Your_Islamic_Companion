from rest_framework import serializers
from .models import Circle, Post, Reaction, Comment


class CircleSerializer(serializers.ModelSerializer):
    member_count = serializers.SerializerMethodField()
    is_member = serializers.SerializerMethodField()

    class Meta:
        model = Circle
        fields = ['id', 'name', 'description', 'gender_restricted',
                  'created_by', 'member_count', 'is_member', 'created_at']
        read_only_fields = ['id', 'created_by', 'created_at']

    def get_member_count(self, obj):
        return obj.members.count()

    def get_is_member(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.members.filter(id=request.user.id).exists()
        return False


class CommentSerializer(serializers.ModelSerializer):
    author_email = serializers.EmailField(source='author.email', read_only=True)

    class Meta:
        model = Comment
        fields = ['id', 'author_email', 'content', 'created_at']
        read_only_fields = ['id', 'author_email', 'created_at']


class PostSerializer(serializers.ModelSerializer):
    author_email = serializers.SerializerMethodField()
    reaction_counts = serializers.SerializerMethodField()
    comment_count = serializers.SerializerMethodField()
    user_reaction = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ['id', 'circle', 'author_email', 'content', 'is_anonymous',
                  'reaction_counts', 'comment_count', 'user_reaction', 'created_at']
        read_only_fields = ['id', 'author_email', 'created_at']

    def get_author_email(self, obj):
        if obj.is_anonymous:
            return "Anonymous"
        return obj.author.email

    def get_reaction_counts(self, obj):
        counts = {}
        for r_type, _ in Reaction.REACTION_CHOICES:
            counts[r_type] = obj.reactions.filter(reaction_type=r_type).count()
        return counts

    def get_comment_count(self, obj):
        return obj.comments.count()

    def get_user_reaction(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            reaction = obj.reactions.filter(user=request.user).first()
            return reaction.reaction_type if reaction else None
        return None