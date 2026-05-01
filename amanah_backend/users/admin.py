from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import AmanahUser


@admin.register(AmanahUser)
class AmanahUserAdmin(UserAdmin):
    list_display = ['email', 'username', 'full_name', 'is_user', 'is_scholar', 'is_nadra_verified', 'amanah_score']
    list_filter = ['is_user', 'is_scholar', 'is_scholar_verified', 'is_nadra_verified', 'gender']
    search_fields = ['email', 'username', 'first_name', 'last_name', 'nadra_id']
    ordering = ['-created_at']

    fieldsets = UserAdmin.fieldsets + (
        ('Role', {'fields': ('is_user', 'is_scholar', 'is_scholar_verified')}),
        ('Profile', {'fields': ('gender', 'date_of_birth', 'city', 'country')}),
        ('NADRA Verification', {'fields': ('nadra_id', 'is_nadra_verified')}),
        ('Scholar Info', {'fields': ('scholar_bio', 'scholar_specialization')}),
        ('Amanah Score', {'fields': ('amanah_score',)}),
    )