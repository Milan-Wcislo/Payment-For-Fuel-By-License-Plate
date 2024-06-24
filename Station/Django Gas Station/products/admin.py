from django.contrib import admin
from .models import Banner, Category, Product

class BannerAdmin(admin.ModelAdmin):
    list_display = ('title', 'image', 'updated_at')
    list_filter = ('title', )

class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', )

class ProductAdmin(admin.ModelAdmin):
    list_display = ('category', 'name', 'image', 'description', 'price', 'updated_at')
    list_filter = ('category', 'price')
    search_fields = ('category', 'name', 'descritpion', 'price')

admin.site.register(Banner, BannerAdmin)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Product, ProductAdmin)

