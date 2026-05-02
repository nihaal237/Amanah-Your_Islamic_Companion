from django.urls import path
from . import views

urlpatterns = [
    path('circles/', views.CircleListCreateView.as_view(), name='circle-list-create'),
    path('circles/<int:pk>/join/', views.CircleJoinLeaveView.as_view(), name='circle-join-leave'),
    path('circles/<int:circle_pk>/posts/', views.PostListCreateView.as_view(), name='post-list-create'),
    path('posts/<int:pk>/', views.PostDeleteView.as_view(), name='post-delete'),
    path('posts/<int:post_pk>/react/', views.ReactionView.as_view(), name='post-react'),
    path('posts/<int:post_pk>/comments/', views.CommentListCreateView.as_view(), name='comment-list-create'),
]