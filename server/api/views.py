from rest_framework import status
import logging

from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Users, Items
from .serializer import UsersSerializer, ItemsSerializer

logger = logging.getLogger(__name__)


# Create your views here.
@api_view(['GET'])
def get_users(req):
    users = Users.objects.all()
    serializedUsers = UsersSerializer(users, many=True).data
    return Response(serializedUsers)


@api_view(['POST'])
def create_user(req):
    data = req.data
    serializer = UsersSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)

    logger.error(f"User creation failed: {serializer.errors}")

    return Response({
        "message": "User creation failed",
        "errors": serializer.errors
    }, status=400)


@api_view(['DELETE', 'GET'])
def delete_user(req, key):
    try:
        user = Users.objects.get(pk=key)
    except Users.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if req.method == 'DELETE':
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    elif req.method == 'GET':
        serializer = UsersSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
def get_items(req):
    items = Items.objects.all()
    serializedItems = ItemsSerializer(items, many=True).data
    return Response(serializedItems)
