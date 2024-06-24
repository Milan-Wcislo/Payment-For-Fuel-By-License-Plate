from django.shortcuts import render, redirect
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

from customers.models import Vehicle
from gas_station.models import Pump, TransactionInProccess, SystemController

@csrf_exempt
def receive_anpr_results(request):
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))

        detected_license_plate = data.get('license_plate')
        recognized_pump = data.get('pump_data')
        print(detected_license_plate)
        try:
            detected_vehicle = Vehicle.objects.get(license_plate=detected_license_plate)

            pump = Pump.objects.get(gas_station__id=recognized_pump["gas_station"], pump_number=recognized_pump["pump_number"])

            TransactionInProccess.objects.create(
                pump=pump,
                customer=detected_vehicle.customer,
                fuel_price=pump.fuel_price,
                fuel_type=pump.fuel_type,
                fuel_amount=pump.fuel_amount
            )

            pump.is_payment_in_process = True
            pump.save()

            print("Transaction created successfully")
            return JsonResponse({'message': 'Data received successfully'}, status=200)

        except Vehicle.DoesNotExist:
            print("Vehicle not found")
            return JsonResponse({'error': 'Vehicle not found'}, status=404)

        except Pump.DoesNotExist:
            print("Pump not found")
            return JsonResponse({'error': 'Pump not found'}, status=404)
    else:
        return JsonResponse({'error': 'Only POST requests are allowed'}, status=400)

def owner(request):
    return HttpResponse("Owner Gas Station")

def simulator(request, station_id):
    controller = SystemController.objects.get(gas_station__id=station_id)
    print(controller)
    context = {
        'controller': controller,
        'station_id': station_id,
    }
    return render(request, 'simulator.html', context)

@csrf_exempt
def prepare_data(request, station_id, pump_number):
    data = json.loads(request.body.decode('utf-8'))
    pump = Pump.objects.get(gas_station__id=station_id, pump_number=pump_number)
    pump.fuel_price = data['fuel_price']
    pump.fuel_amount = data['fuel_amount']
    pump.fuel_type = data['fuel_type']
    pump.is_ready_to_pay = True
    pump.save()
    return redirect('simulator', station_id)