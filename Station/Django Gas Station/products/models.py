from django.db import models

class Banner(models.Model):
    image = models.ImageField(upload_to='banners/%Y/%m/%d')
    title = models.CharField(max_length=100, default="Station")
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.title
    

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    
    
class Product(models.Model):
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True)
    name = models.CharField(max_length=50, unique=True)
    image = models.ImageField(upload_to='products/%Y/%m/%d')
    description = models.TextField(blank=True)
    price = models.PositiveIntegerField(default=0)
    is_bestseller = models.BooleanField(default=False)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name