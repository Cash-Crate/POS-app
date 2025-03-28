import logging

from django.db.models import F
from django.db import connection

from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import CrudLogging, ItemAttributes, Items, ItemTypes, LoginsLoggin, Users
from .serializer import (
    CrudSerializer,
    ItemAttributesSerializer,
    ItemsSerializer,
    ItemTypesSerializer,
    UsersSerializer,
)

logger = logging.getLogger(__name__)


# ======================================USERS==================================
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


@api_view(['DELETE', 'GET', 'PUT'])
def user_by_id(req, key):
    try:
        user = Users.objects.get(pk=key)
    except Users.DoesNotExist:
        return Response(status=404)

    if req.method == 'PUT':
        serializer = UsersSerializer(user, data=req.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=200)

        logger.error(f"User update failed: {serializer.errors}")
        return Response({
            'error': serializer.errors
        }, status=400),

    if req.method == 'DELETE':
        user.delete()
        return Response(status=204)

    if req.method == 'GET':
        serializer = UsersSerializer(user)
        return Response(serializer.data, status=200)


@api_view(['GET'])
def get_logins(req):
    logins = LoginsLoggin.objects.select_related('user_id').annotate(
        email=F('user_id__user_email')
    ).values(
        'email',
        'login_at',
        'logout_at',
        'ip_address',
        'device_type',
        'browser',
        'cpu_arch',
        'host',
        'origin'
    )
    return Response(list(logins))
# ======================================USERS==================================


# ======================================ITEM TYPES=============================
@api_view(['GET'])
def get_item_types(req):
    itemTypes = ItemTypes.objects.all()
    serializedItemTypes = ItemTypesSerializer(itemTypes, many=True).data
    return Response(serializedItemTypes)


@api_view(['POST'])
def create_item_type(req):
    data = req.data
    serializer = ItemTypesSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)

    logger.error(f"Item Type creation failed: {serializer.errors}")

    return Response({
        "message": "Item Type creation failed",
        "errors": serializer.errors
    }, status=400)
# ======================================ITEM TYPES=============================


# ======================================ITEMS==================================
@api_view(['GET'])
def get_items(req):
    items = Items.objects.select_related('item_type')\
        .prefetch_related('itemattributes_set')\
        .annotate(
            item_type_name=F('item_type__item_type_name'))\
        .values(
        'item_id',
        'item_type_name',
        'item_name',
        'item_desc',
        'item_image',
        'price',
        'quantity'
    )  #.filter(item_attr='Brand') // for filtering in case

    item_attrs = ItemAttributes.objects.values('item_id', 'attr_name', 'attr_value')
    attrs_dict = {}
    for attr in item_attrs:
        item_id = attr['item_id']
        if item_id not in attrs_dict:
            attrs_dict[item_id] = {}
        attrs_dict[item_id][attr['attr_name']] = attr['attr_value']

    result = []
    for item in items:
        item_with_attrs = item.copy()
        if item['item_id'] in attrs_dict:
            item_with_attrs.update(attrs_dict[item['item_id']])
        result.append(item_with_attrs)

    return Response(list(result))


@api_view(['POST'])
def create_item(req):
    data = req.data
    serializer = ItemsSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)

    logger.error(f"Item creation failed: {serializer.errors}")

    return Response({
        "message": "Item creation failed",
        "errors": serializer.errors
    }, status=400)


@api_view(['PUT', 'DELETE', 'GET'])
def item_by_id(req, key):
    try:
        item = Items.objects.select_related('item_type')\
            .annotate(
            item_type_name=F('item_type__item_type_name')
        ).get(pk=key)
    except Items.DoesNotExist:
        return Response(status=404)

    if req.method == 'PUT':
        serializer = ItemsSerializer(item, data=req.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=200)

        logger.error(f"Item update failed: {serializer.errors}")
        return Response({
            "message": "Item update failed",
            "errors": serializer.errors
        }, status=400)

    if req.method == 'DELETE':
        item.delete()
        return Response(status=204)

    if req.method == 'GET':
        item_attrs = ItemAttributes.objects.filter(item_id=key)\
            .values('attr_name', 'attr_value')

        item_dict = {
            'item_id': item.pk,
            'item_name': item.item_name,
            'item_desc': item.item_desc,
            'item_image': item.item_image,
            'price': item.price,
            'quantity': item.quantity,
            'item_type_name': item.item_type_name
        }

        for attr in item_attrs:
            item_dict[attr['attr_name']] = attr['attr_value']

        return Response(item_dict, status=200)
# ======================================ITEMS==================================


# ======================================ITEM ATTRIBUTES========================
@api_view(['GET'])
def get_item_attrs(req, key):
    try:
        Items.objects.get(pk=key)
    except Items.DoesNotExist:
        return Response(status=404)

    item_attrs = ItemAttributes.objects.filter(item_id=key)\
        .values('attr_name', 'attr_value')
    return Response(list(item_attrs))


@api_view(['POST'])
def create_item_attr(req, key):
    try:
        Items.objects.get(pk=key)
    except Items.DoesNotExist:
        return Response(status=404)

    data = req.data.copy()
    data['item_id'] = key

    try:
        serializer = ItemAttributesSerializer(data=data)
        if serializer.is_valid():
            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO item_attributes (item_id, attr_name, attr_value) VALUES (%s, %s, %s)",
                    [key, serializer.validated_data['attr_name'], serializer.validated_data['attr_value']]
                )
                return Response(serializer.data, status=201)
        else:
            return Response({
                "message": "Item Attribute creation failed",
                "errors": serializer.errors
            }, status=400)
    except Exception as e:
        logger.error(f"Item Attribute creation failed: {e}")
        return Response({
            "message": "Item Attribute creation failed",
            "errors": str(e)
        }, status=400)
# ======================================ITEM ATTRIBUTES========================


# ======================================CRUD LOGGINGS==========================
@api_view(['GET'])
def get_crud_logs(req):
    crudLogs = CrudLogging.objects.all()
    serializedCrudLogs = CrudSerializer(crudLogs, many=True).data
    return Response(serializedCrudLogs)


@api_view(['POST'])
def create_crud_log(req):
    data = req.data
    serializer = CrudSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)

    logger.error(f"Crud Log creation failed: {serializer.errors}")

    return Response({
        "message": "Crud Log creation failed",
        "errors": serializer.errors
    }, status=400)
# ======================================CRUD LOGGINGS==========================
