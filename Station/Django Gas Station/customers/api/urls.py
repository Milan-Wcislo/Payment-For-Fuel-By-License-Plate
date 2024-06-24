from django.urls import path
from . import views
from .views import MyTokenObtainPairView

from rest_framework_simplejwt.views import (
    TokenRefreshView,
)

urlpatterns = [
    path('token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('loyalty-program/', views.get_loyalty_program_view, name="get_loyalty_program_view"),
    path('coupons/', views.get_coupons_view, name="get_coupons_view"),
    path('transactions/', views.get_transactions_view, name="get_transactions_view"),
]