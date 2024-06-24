from django.urls import path

from . import views

urlpatterns = [
    path('receive_data/', views.receive_anpr_results, name='receive_data'),
    path('owner', views.owner, name="owner"),
    path('<int:station_id>/simulator/', views.simulator, name="simulator"),
    path('<int:station_id>/prepare_data/<int:pump_number>', views.prepare_data, name="prepare_data"),
]