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
    path('api/prayer/', include('prayer.urls')),   # ← ADDED
]