from growth.services import calculate_amanah_score

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .models import QuranBookmark
from .serializers import QuranBookmarkSerializer
from . import services
import requests

class SurahListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            data = services.get_all_surahs()
            return Response({"count": len(data), "surahs": data})
        except requests.RequestException as e:
            return Response({"error": "Failed to fetch surahs", "detail": str(e)},
                            status=status.HTTP_502_BAD_GATEWAY)


class SurahDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, surah_number):
        if not 1 <= surah_number <= 114:
            return Response({"error": "Surah number must be between 1 and 114."},
                            status=status.HTTP_400_BAD_REQUEST)
        try:
            data = services.get_surah_detail(surah_number)
            return Response(data)
        except requests.RequestException as e:
            return Response({"error": "Failed to fetch surah", "detail": str(e)},
                            status=status.HTTP_502_BAD_GATEWAY)


class QuranSearchView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        query = request.query_params.get("q", "").strip()
        if not query:
            return Response({"error": "Query parameter 'q' is required."},
                            status=status.HTTP_400_BAD_REQUEST)
        try:
            results = services.search_quran(query)
            return Response({"query": query, "count": len(results), "results": results})
        except requests.RequestException as e:
            return Response({"error": "Search failed", "detail": str(e)},
                            status=status.HTTP_502_BAD_GATEWAY)


class BookmarkListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        bookmarks = QuranBookmark.objects.filter(user=request.user)
        serializer = QuranBookmarkSerializer(bookmarks, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = QuranBookmarkSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            calculate_amanah_score(request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BookmarkDeleteView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, pk):
        try:
            bookmark = QuranBookmark.objects.get(pk=pk, user=request.user)
            bookmark.delete()
            return Response({"message": "Bookmark removed."}, status=status.HTTP_200_OK)
        except QuranBookmark.DoesNotExist:
            return Response({"error": "Bookmark not found."}, status=status.HTTP_404_NOT_FOUND)