from django.db.models import Q
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .models import Circle, Post, Reaction, Comment
from .serializers import CircleSerializer, PostSerializer, CommentSerializer


class CircleListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        circles = Circle.objects.all()
        serializer = CircleSerializer(circles, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        serializer = CircleSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save(created_by=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CircleJoinLeaveView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        try:
            circle = Circle.objects.get(pk=pk)
        except Circle.DoesNotExist:
            return Response({"error": "Circle not found."}, status=status.HTTP_404_NOT_FOUND)

        if circle.members.filter(id=request.user.id).exists():
            circle.members.remove(request.user)
            return Response({"message": "Left circle."})
        else:
            circle.members.add(request.user)
            return Response({"message": "Joined circle."})


class PostListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, circle_pk):
        try:
            circle = Circle.objects.get(pk=circle_pk)
        except Circle.DoesNotExist:
            return Response({"error": "Circle not found."}, status=status.HTTP_404_NOT_FOUND)

        posts = Post.objects.filter(circle=circle)
        serializer = PostSerializer(posts, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request, circle_pk):
        try:
            circle = Circle.objects.get(pk=circle_pk)
        except Circle.DoesNotExist:
            return Response({"error": "Circle not found."}, status=status.HTTP_404_NOT_FOUND)

        if not circle.members.filter(id=request.user.id).exists():
            return Response({"error": "You must join this circle to post."},
                            status=status.HTTP_403_FORBIDDEN)

        data = request.data.copy()
        data['circle'] = circle.id
        serializer = PostSerializer(data=data, context={'request': request})
        if serializer.is_valid():
            serializer.save(author=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PostDeleteView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, pk):
        try:
            post = Post.objects.get(pk=pk, author=request.user)
            post.delete()
            return Response({"message": "Post deleted."})
        except Post.DoesNotExist:
            return Response({"error": "Post not found or not yours."},
                            status=status.HTTP_404_NOT_FOUND)


class ReactionView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, post_pk):
        try:
            post = Post.objects.get(pk=post_pk)
        except Post.DoesNotExist:
            return Response({"error": "Post not found."}, status=status.HTTP_404_NOT_FOUND)

        reaction_type = request.data.get('reaction_type')
        valid_types = [r[0] for r in Reaction.REACTION_CHOICES]
        if reaction_type not in valid_types:
            return Response({"error": f"Invalid reaction. Choose from: {valid_types}"},
                            status=status.HTTP_400_BAD_REQUEST)

        reaction, created = Reaction.objects.get_or_create(
            post=post, user=request.user,
            defaults={'reaction_type': reaction_type}
        )

        if not created:
            if reaction.reaction_type == reaction_type:
                reaction.delete()
                return Response({"message": "Reaction removed."})
            else:
                reaction.reaction_type = reaction_type
                reaction.save()
                return Response({"message": "Reaction updated.", "reaction_type": reaction_type})

        return Response({"message": "Reaction added.", "reaction_type": reaction_type},
                        status=status.HTTP_201_CREATED)


class CommentListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, post_pk):
        try:
            post = Post.objects.get(pk=post_pk)
        except Post.DoesNotExist:
            return Response({"error": "Post not found."}, status=status.HTTP_404_NOT_FOUND)

        comments = Comment.objects.filter(post=post)
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)

    def post(self, request, post_pk):
        try:
            post = Post.objects.get(pk=post_pk)
        except Post.DoesNotExist:
            return Response({"error": "Post not found."}, status=status.HTTP_404_NOT_FOUND)

        content = request.data.get('content', '').strip()
        if not content:
            return Response({"error": "Comment content is required."},
                            status=status.HTTP_400_BAD_REQUEST)

        comment = Comment.objects.create(post=post, author=request.user, content=content)
        serializer = CommentSerializer(comment)
        return Response(serializer.data, status=status.HTTP_201_CREATED)