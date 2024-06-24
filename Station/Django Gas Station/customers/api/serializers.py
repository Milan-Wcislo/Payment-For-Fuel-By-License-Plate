from rest_framework import serializers
from customers.models import Coupon, LoyaltyProgram
from gas_station.models import Transaction

class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = '__all__'

class LoyaltyProgramSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoyaltyProgram
        fields = '__all__'

class TransactionSerializer(serializers.ModelSerializer):
    timestamp = serializers.SerializerMethodField()

    def get_timestamp(self, obj):
        # Assuming your date field in the Transaction model is named 'date'
        original_date = obj.timestamp
        if original_date:
            # Extracting the date before 'T'
            formatted_date = str(original_date).split('T')[0]
            return formatted_date
        else:
            return None

    class Meta:
        model = Transaction
        fields = '__all__'
