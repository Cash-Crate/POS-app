from django.urls import path
from .views import (
    get_users,
    create_user,
    get_crud_logs,
    user_by_id,
    get_items,
    item_by_id,
    create_item,
    get_logins,
    get_item_types,
    create_item_type,
)

urlpatterns = [
    path('users/', get_users, name='get_users'),
    path('users/create/', create_user, name='create_user'),
    path('users/<int:key>/', user_by_id, name='delete_user'),
    path('crud/', get_crud_logs, name='get_crud_logs'),
    path('logins/', get_logins, name='get_logins'),
    path('itemtypes/', get_item_types, name='get_items_types'),
    path('itemtypes/create/', create_item_type, name='create_item_type'),
    path('items/', get_items, name='get_items'),
    path('items/<int:key>', item_by_id, name='update_item'),
    path('items/create/', create_item, name='create_item'),
]
