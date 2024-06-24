from django.urls import path, include

from . import views

urlpatterns = [
    path('', views.index, name="index"),
    path('products', views.products, name="products"),
    path('buy_product/<int:product_id>', views.buy_product, name="buy_product"),
]