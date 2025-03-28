from rest_framework import serializers

from .models import (BoughtItems, CrudLogging, ItemAttributes, Items,
                     ItemTypes, LoginsLoggin, OnetimeTrans, RecurringTrans,
                     RecurringTransPayment, Users)


class UsersSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = '__all__'


class LoginsSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoginsLoggin
        fields = '__all__'


class CrudSerializer(serializers.ModelSerializer):
    class Meta:
        model = CrudLogging
        fields = '__all__'


class ItemTypesSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemTypes
        fields = '__all__'


class ItemAttributesSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemAttributes
        fields = ['item_id', 'attr_name', 'attr_value']


class ItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Items
        fields = '__all__'


class OnetimeTransSerializer(serializers.ModelSerializer):
    class Meta:
        model = OnetimeTrans
        fields = '__all__'


class RecurringTransSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecurringTrans
        fields = '__all__'


class RecurringTransPaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecurringTransPayment
        fields = '__all__'


class BoughtItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoughtItems
        fields = '__all__'
