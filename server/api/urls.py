from django.urls import path
from .views import (get_users,
                    create_user,
                    delete_user,
                    get_items,
                    update_item,
                    create_item,
                    get_logins,
                    get_item_types,
                    create_item_type
                    )

urlpatterns = [
    path('users/', get_users, name='get_users'),
    path('users/create/', create_user, name='create_user'),
    path('users/<int:key>/', delete_user, name='delete_user'),
    path('items/', get_items, name='get_items'),
    path('items/<int:key>', update_item, name='update_item'),
    path('items/create/', create_item, name='create_item'),
    path('itemtypes/', get_item_types, name='get_items_types'),
    path('itemtypes/create/', create_item_type, name='create_item_type'),
    path('logins/', get_logins, name='get_logins')
]
