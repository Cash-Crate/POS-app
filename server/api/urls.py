from django.urls import path
from .views import get_users, create_user, delete_user, get_items

urlpatterns = [
    path('users/', get_users, name='get_users'),
    path('users/create/', create_user, name='create_user'),
    path('users/<int:key>/', delete_user, name='delete_user'),
    path('items/', get_items, name='get_items')
]
