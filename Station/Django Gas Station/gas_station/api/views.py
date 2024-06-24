from decimal import Decimal
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.http import JsonResponse
from django.contrib.auth.models import User

from .serializers import TransactionInProccessSerializer, PumpSerializer
from customers.models import LoyaltyProgram
from gas_station.models import TransactionInProccess, Transaction, Pump


@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def get_transaction_view(request):
    if request.method == 'GET':
        user = request.user
        loyalty_program = TransactionInProccess.objects.filter(customer=user).first()
        serializer = TransactionInProccessSerializer(loyalty_program, many=False)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        try:
            user = request.user
            transaction_in_proccess = TransactionInProccess.objects.filter(customer=user).first()

            transaction_in_proccess.pump.is_ready_to_pay = False
            transaction_in_proccess.pump.is_payment_in_process = False
            transaction_in_proccess.pump.save()
            
            save_transaction = Transaction.objects.create(
                customer=user,
                pump=transaction_in_proccess.pump,
                fuel_price=transaction_in_proccess.fuel_price,
                fuel_type=transaction_in_proccess.fuel_type,
                fuel_amount=transaction_in_proccess.fuel_amount
            )
            transaction_in_proccess.delete()

            loyalty_program, created = LoyaltyProgram.objects.get_or_create(customer=user)
            loyalty_program.loyalty_points += int(Decimal(save_transaction.fuel_price))
            loyalty_program.save()
            return Response({"message": f"Transaction created successfully for {user}"}, status=200)
            
        except TransactionInProccess.DoesNotExist:
            return Response({"message": "Transaction not found for the user"}, status=404)
        

@api_view(['GET'])
def get_pump_view(request, station_id, pump_number):
    pump = Pump.objects.filter(gas_station__id=station_id, pump_number=pump_number).first() 
    if pump:
        serializer = PumpSerializer(pump, many=False)
        return Response(serializer.data)
    else:
        return JsonResponse({"error": "Pump not found"}, status=404)
        
