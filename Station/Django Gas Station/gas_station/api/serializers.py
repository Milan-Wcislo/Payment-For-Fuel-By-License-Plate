from rest_framework import serializers
from gas_station.models import TransactionInProccess, Pump

class TransactionInProccessSerializer(serializers.ModelSerializer):
    class Meta:
        model = TransactionInProccess
        fields = '__all__'

class PumpSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pump
        fields = '__all__'
        