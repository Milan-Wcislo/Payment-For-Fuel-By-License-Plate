from django.contrib import admin
from .models import GasStation, Address, Owner, Pump, Tank, Transaction, TransactionInProccess, SystemController

class AddressInline(admin.TabularInline):
    model = Address
    extra = 1

class OwnerInline(admin.StackedInline):
    model = Owner
    extra = 1

class PumpInline(admin.TabularInline):
    model = Pump
    extra = 2

class TankInline(admin.TabularInline):
    model = Tank
    extra = 1

class SystemControllerAdmin(admin.TabularInline):
    model = SystemController
    extra = 1

class GasStationAdmin(admin.ModelAdmin):
    list_display = ['gas_station_name', 'location_url', 'is_open_24_hours', 'address']
    list_filter = ['gas_station_name']
    search_fields = ['gas_station_name', 'owner__name']
    
    inlines = [
        AddressInline,
        OwnerInline,
        TankInline,
        PumpInline,
        SystemControllerAdmin,
    ]


class TransactionInProccessAdmin(admin.ModelAdmin):
    list_display = ['customer', 'pump', 'fuel_price', 'fuel_type', 'fuel_amount']

class TransactionAdmin(admin.ModelAdmin):
    list_display = ['customer', 'pump', 'fuel_price', 'fuel_type', 'fuel_amount', 'payment_method']


admin.site.register(GasStation, GasStationAdmin)
admin.site.register(Transaction, TransactionAdmin)
admin.site.register(TransactionInProccess, TransactionInProccessAdmin)