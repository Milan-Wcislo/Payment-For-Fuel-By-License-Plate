# views.py
from django.shortcuts import redirect, render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages

from customers.models import Coupon
from .models import Banner, Category, Product

from .utils import get_loyalty_program, generate_coupon_code, generate_coupon_barcode


@login_required
def buy_product(request, product_id):
    if request.user.is_authenticated:
        loyalty_program = get_loyalty_program(request.user)
        if loyalty_program is None:
            messages.error(request, "You need to join the loyalty program to buy products!")
            return redirect('index')

        product = get_object_or_404(Product, id=product_id)
        if loyalty_program.buy_product(product.price):
            coupon_code = generate_coupon_code(request.user.username, product_id)
            image_path = generate_coupon_barcode(coupon_code)
            Coupon.objects.create(user=request.user, name=product.name, code=coupon_code, product_image=product.image, code_image=image_path)  
            messages.success(request, 'Coupon bought successfully!')
            return redirect('coupons')
        else:
            messages.error(request, "You don't have enough bolts!")
            return redirect('index') 
    else:
        messages.success(request, 'Login successful!')
        return redirect('user_login')

def index(request):
    banner = Banner.objects.first()
    products = Product.objects.all()
    loyalty_program = get_loyalty_program(request.user)

    context = {
        "banner": banner,
        "products": products,
        'loyalty_program': loyalty_program,
    }
    return render(request, "index.html", context)

def products(request):
    categorys = Category.objects.order_by("name")
    products = Product.objects.all()
    loyalty_program = get_loyalty_program(request.user)

    context = {
        "categorys": categorys,
        "products": products,
        'loyalty_program': loyalty_program,
    }
    return render(request, "products.html", context)
    