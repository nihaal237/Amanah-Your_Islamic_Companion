from django.contrib import admin
from .models import Circle, Post, Reaction, Comment

@admin.register(Circle)
class CircleAdmin(admin.ModelAdmin):
    list_display = ['name', 'gender_restricted', 'created_by', 'created_at']
    search_fields = ['name']

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ['author', 'circle', 'is_anonymous', 'created_at']
    list_filter = ['circle', 'is_anonymous']

@admin.register(Reaction)
class ReactionAdmin(admin.ModelAdmin):
    list_display = ['user', 'post', 'reaction_type']

@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ['author', 'post', 'created_at']