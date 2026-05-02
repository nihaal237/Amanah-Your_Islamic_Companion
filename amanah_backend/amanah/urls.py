from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),

    # Auth endpoints (register, login, logout, profile)
    path('api/auth/', include('users.urls')),

    # JWT token refresh
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # Prayer engine (times, qibla, log, history) — FR6-FR8
    path('api/prayer/', include('prayer.urls')),

    # Quran endpoints (surahs, verses, search, bookmarks) — FR15-FR17
    path('api/quran/', include('quran.urls')),

    # Community features (posts, comments, likes, follows) — FR9-FR14
    path('api/community/', include('community.urls')),

    # Scholar Q&A (ask, answer, pending, archive) — FR22-FR25
    path('api/scholar/', include('scholar.urls')),

    # Growth and analytics (mood, goals, score) — FR26-FR28
    path('api/growth/', include('growth.urls')),
]