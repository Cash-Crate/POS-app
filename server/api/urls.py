from django.urls import path
from .views import get_users

urlpatterns = [
    path('users/', get_users, name='get_users'),
    # path('users/create/', create_user, name='create_user'),
    # path('users/<int:key>/', delete_user, name='delete_user')
]
