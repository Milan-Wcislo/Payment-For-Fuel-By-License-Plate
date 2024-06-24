from django.contrib import admin
from .models import Coupon, LoyaltyProgram, Vehicle

class VehicleAdmin(admin.ModelAdmin):
    list_display = ('customer', 'brand', 'model', 'license_plate')

class CouponAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'code', 'product_image', 'code_image', 'created_at')


class LoyaltyProgramAdmin(admin.ModelAdmin):
    list_display = ('customer', 'loyalty_points', 'discount_percentage')



admin.site.register(Vehicle, VehicleAdmin)
admin.site.register(Coupon, CouponAdmin)
admin.site.register(LoyaltyProgram, LoyaltyProgramAdmin)


