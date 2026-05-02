from django.urls import path
from . import views

urlpatterns = [
    path('surahs/', views.SurahListView.as_view(), name='surah-list'),
    path('surah/<int:surah_number>/', views.SurahDetailView.as_view(), name='surah-detail'),
    path('search/', views.QuranSearchView.as_view(), name='quran-search'),
    path('bookmark/', views.BookmarkListCreateView.as_view(), name='bookmark-list-create'),
    path('bookmarks/', views.BookmarkListCreateView.as_view(), name='bookmark-list'),
    path('bookmark/<int:pk>/', views.BookmarkDeleteView.as_view(), name='bookmark-delete'),
]