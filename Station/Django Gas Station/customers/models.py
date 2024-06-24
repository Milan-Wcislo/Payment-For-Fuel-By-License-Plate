from django.db import models
from django.contrib.auth.models import User


class Vehicle(models.Model):
    customer = models.ForeignKey(User, related_name='vehicles', on_delete=models.CASCADE)
    license_plate = models.CharField(max_length=20, unique=True)
    ENGINE_TYPE_CHOICES = [
        ('Gasoline', 'Gasoline'),
        ('Diesel', 'Diesel'),
        ('Electric', 'Electric'),
        ('Hybrid', 'Hybrid'),
    ]
    engine_type = models.CharField(max_length=50, choices=ENGINE_TYPE_CHOICES)
    brand = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    def __str__(self):
        return self.license_plate
    

class Coupon(models.Model):
    user = models.ForeignKey(User, related_name='coupons', on_delete=models.CASCADE, default="")
    name = models.CharField(max_length=255, default="")
    code = models.CharField(max_length=255, unique=True)
    product_image = models.ImageField(default="")
    code_image = models.ImageField(upload_to='barcodes/')
    created_at = models.DateTimeField(auto_now_add=True)


class LoyaltyProgram(models.Model):
    customer = models.OneToOneField(User, related_name='loyalty_program', on_delete=models.CASCADE)
    loyalty_points = models.PositiveIntegerField(default=0)
    discount_percentage = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)

    def buy_product(self, product_price):
        if self.loyalty_points >= product_price:
            self.loyalty_points -= product_price
            self.save()
            return True
        else:
            return False
