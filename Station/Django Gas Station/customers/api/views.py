from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth.models import User

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import CouponSerializer, LoyaltyProgramSerializer, TransactionSerializer
from customers.models import Coupon, LoyaltyProgram
from gas_station.models import Transaction



class MyTokenObtainPairSerializer(TokenObtainPairSerializer): 
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token['username'] = user.username

        return token
    
class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_loyalty_program_view(request):
    user = request.user
    loyalty_program = LoyaltyProgram.objects.filter(customer=user).first()
    serializer = LoyaltyProgramSerializer(loyalty_program, many=False)
    return Response(serializer.data)
    

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_coupons_view(request):
    user = request.user
    coupons = Coupon.objects.filter(user=user)
    serializer = CouponSerializer(coupons, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_transactions_view(request):
    user = request.user
    payment = Transaction.objects.filter(customer=user).order_by('-timestamp')
    print(payment)
    serializer = TransactionSerializer(payment, many=True)
    return Response(serializer.data) 
