from django.db import models
from django.contrib.auth.models import User
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError
import json

from .utils import FUEL_TYPE_CHOICES


class Owner(models.Model):
    gas_station = models.ForeignKey('gas_station.GasStation', related_name='owner', on_delete=models.SET_NULL, null=True)
    user = models.OneToOneField(User, related_name='owner', on_delete=models.CASCADE)
    phone = models.CharField(max_length=20)
    owner_from = models.DateTimeField(auto_now_add=True)
    other_information = models.TextField(blank=True)
    billing_address = models.CharField(max_length=100)

    def __str__(self):
        return self.user.username
    

class TransactionInProccess(models.Model):
    pump = models.ForeignKey('gas_station.Pump', related_name='create_transaction_set', on_delete=models.SET_NULL, null=True)
    customer = models.ForeignKey(User, related_name='create_transaction_set', on_delete=models.SET_NULL, null=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    fuel_price = models.DecimalField(max_digits=10, decimal_places=2)
    fuel_type = models.CharField(max_length=100)
    fuel_amount = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Transaction {self.id}"


class Transaction(models.Model):
    pump = models.ForeignKey('gas_station.Pump', related_name='transaction_set', on_delete=models.SET_NULL, null=True)
    customer = models.ForeignKey(User, related_name='transaction_set', on_delete=models.SET_NULL, null=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    PAYMENT_METHOD_CHOICES = [
        ('Cash', 'Cash'),
        ('Credit Card', 'Credit Card'),
        ('Debit Card', 'Debit Card'),
    ]
    payment_method = models.CharField(max_length=50, choices=PAYMENT_METHOD_CHOICES)
    fuel_price = models.DecimalField(max_digits=10, decimal_places=2)
    fuel_type = models.CharField(max_length=100)
    fuel_amount = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Transaction {self.id}"


class Tank(models.Model):
    gas_station = models.ForeignKey('gas_station.GasStation', related_name='tanks', on_delete=models.SET_NULL, null=True)
    tank_number = models.PositiveIntegerField(unique=True, default=1)
    fuel_type = models.CharField(max_length=100, choices=FUEL_TYPE_CHOICES)
    capacity = models.DecimalField(max_digits=10, decimal_places=2)
    current_level = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.fuel_type} Tank at {self.gas_station}"
    

class Pump(models.Model):
    gas_station = models.ForeignKey('gas_station.GasStation', related_name='pumps', on_delete=models.SET_NULL, null=True)
    pump_number = models.PositiveIntegerField(unique=True, default=1)
    fuel_type = models.CharField(max_length=100, choices=FUEL_TYPE_CHOICES)
    fuel_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    fuel_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    is_ready_to_pay = models.BooleanField(default=False)
    is_payment_in_process = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"Pump {self.id} at {self.gas_station}"


class SystemController(models.Model):
    gas_station = models.OneToOneField('gas_station.GasStation', related_name='system_controller', on_delete=models.CASCADE)
    petrol_price = models.DecimalField(max_digits=4, decimal_places=2, default=0.0)
    diesel_price = models.DecimalField(max_digits=4, decimal_places=2, default=0.0)
    electric_price = models.DecimalField(max_digits=4, decimal_places=2, default=0.0)
    last_updated = models.DateTimeField(auto_now=True)

    @property
    def update_fuel_prices(self, new_prices):
        try:
            json.loads(new_prices)
        except json.JSONDecodeError:
            raise ValidationError("Invalid JSON format for fuel prices")

        self.fuel_prices = new_prices
        self.save()

    @property
    def get_fuel_prices(self):
        return json.loads(self.fuel_prices)

    def __str__(self):
        return f"System Controller for {self.gas_station}"
    

class Address(models.Model):
    gas_station = models.OneToOneField('gas_station.GasStation', related_name='address', on_delete=models.SET_NULL, null=True)
    address = models.CharField(max_length=200)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    zipcode = models.CharField(max_length=20)

    def __str__(self):
        return self.address


class GasStation(models.Model):
    gas_station_name = models.CharField(max_length=100)
    location_url = models.URLField(max_length=255, validators=[URLValidator()])
    opening_time = models.TimeField(null=True, blank=True)
    closing_time = models.TimeField(null=True, blank=True)
    is_open_24_hours = models.BooleanField(default=True)

    def __str__(self):
        return self.gas_station_name
