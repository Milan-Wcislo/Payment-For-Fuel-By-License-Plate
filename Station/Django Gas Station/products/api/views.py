from django.shortcuts import get_object_or_404
from products.utils import generate_coupon_barcode, generate_coupon_code, get_loyalty_program
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib import messages

from customers.models import Coupon
from .serializers import ProductSerializer, CategorySerializer
from products.models import Product, Category

@api_view(['GET'])
def get_routes(request):
    routes = [
        {
        'Endpoint': '/api/products/',
        'method': 'GET',
        'body': None,
        'description': 'Returns an array of products'
        },
        {
        'Endpoint': '/api/products/id',
        'method': 'GET',
        'body': None,
        'description': 'Returns a single product'
        }
    ]
    return Response(routes)

@api_view(['GET'])
def get_categories_and_products(request):
    categories = Category.objects.all()
    products = Product.objects.all()

    category_serializer = CategorySerializer(categories, many=True)
    product_serializer = ProductSerializer(products, many=True)

    response_data = {
        'categories': category_serializer.data,
        'products': product_serializer.data
    }

    return Response(response_data)

@api_view(['GET'])
def get_product(request, product_id):
    product = Product.objects.get(id=product_id)
    serializer = ProductSerializer(product, many=False)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def buy_product(request, product_id):
    user = request.user
    loyalty_program = get_loyalty_program(user)
    
    if loyalty_program is None:
        messages.error(request, "You need to join the loyalty program to buy products!")
        return Response({"error": "You need to join the loyalty program to buy products!"})

    product = get_object_or_404(Product, id=product_id)

    if loyalty_program.buy_product(product.price):
        coupon_code = generate_coupon_code(user.username, product_id)
        image_path = generate_coupon_barcode(coupon_code)
        Coupon.objects.create(user=user, name=product.name, code=coupon_code, product_image=product.image, code_image=image_path)  
        messages.success(request, 'Coupon bought successfully!')
        return Response({"message": "Coupon bought successfully!"})
    else:
        messages.error(request, "You don't have enough bolts!")
        return Response({"error": "You don't have enough bolts!"})
    