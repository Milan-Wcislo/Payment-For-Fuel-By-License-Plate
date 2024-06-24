from django.urls import path
from . import views


urlpatterns = [
    path('get-transaction/', views.get_transaction_view, name='get_transaction_view'),
    path('<int:station_id>/get-pump/<int:pump_number>/', views.get_pump_view, name='get_pump_view'),
]   
