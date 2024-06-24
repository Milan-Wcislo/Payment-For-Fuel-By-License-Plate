from django.urls import path
from . import views

urlpatterns = [
    path('routes/', views.get_routes),
    path('', views.get_categories_and_products),
    path('<int:product_id>/', views.get_product),
    path('buy-product/<int:product_id>/', views.buy_product, name='buy_product_api'),
]
