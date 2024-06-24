from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from django.contrib import messages
from django.contrib.auth.models import User


from .forms import CreateUserForm
from .forms import CreateUserForm, CreateVehicleForm
from .models import LoyaltyProgram, Coupon

from django.contrib import messages
from django.shortcuts import render, redirect
from .forms import CreateUserForm, CreateVehicleForm
from .models import LoyaltyProgram, User, Vehicle

def register(request):
    user_form = CreateUserForm()
    vehicle_form = CreateVehicleForm()

    if request.method == 'POST':
        user_form = CreateUserForm(request.POST)
        vehicle_form = CreateVehicleForm(request.POST)

        if user_form.is_valid() and vehicle_form.is_valid():
            username = user_form.cleaned_data['username']
            email = user_form.cleaned_data['email']
            password = user_form.cleaned_data['password1']
            confirm_password = user_form.cleaned_data['password2']
            license_plate = vehicle_form.cleaned_data['license_plate']
            engine_type = vehicle_form.cleaned_data['engine_type']
            brand = vehicle_form.cleaned_data['brand']
            model = vehicle_form.cleaned_data['model']

            if password == confirm_password:
                if User.objects.filter(username=username).exists():
                    messages.error(request, "Username already exists")
                else:
                    user = user_form.save()
                    LoyaltyProgram.objects.create(customer=user)

                    Vehicle.objects.create(
                        customer=user,
                        license_plate=license_plate,
                        engine_type=engine_type,
                        brand=brand,
                        model=model
                    )

                    messages.success(request, "User, LoyaltyProgram, and Vehicle created successfully")
                    return redirect('user_login')
            else:
                messages.error(request, "Passwords do not match")
        else:
            if 'username' in user_form.errors:
                messages.error(request, f"Invalid username: {user_form.errors['username'][0]}")
            elif 'email' in user_form.errors:
                messages.error(request, f"Invalid email: {user_form.errors['email'][0]}")
            elif 'password1' in user_form.errors:
                messages.error(request, f"Invalid password: {user_form.errors['password1'][0]}")
            elif 'password2' in user_form.errors:
                messages.error(request, f"Invalid password confirmation: {user_form.errors['password2'][0]}")

            if 'license_plate' in vehicle_form.errors:
                messages.error(request, f"Invalid license plate: {vehicle_form.errors['license_plate'][0]}")
            elif 'engine_type' in vehicle_form.errors:
                messages.error(request, f"Invalid engine type: {vehicle_form.errors['engine_type'][0]}")
            elif 'brand' in vehicle_form.errors:
                messages.error(request, f"Invalid brand: {vehicle_form.errors['brand'][0]}")
            elif 'model' in vehicle_form.errors:
                messages.error(request, f"Invalid model: {vehicle_form.errors['model'][0]}")
            else:
                messages.error(request, "Invalid vehicle form")

    context = {
        "user_form": user_form,
        "vehicle_form": vehicle_form,
    }

    return render(request, "accounts/register.html", context)


def user_login(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            messages.success(request, 'Login successful!')
            return redirect('index')
        else:
            messages.error(request, 'Invalid username or password')
            return redirect('user_login')

    return render(request, 'accounts/login.html')

@login_required
def user_logout(request):
    logout(request)
    messages.success(request, 'Logout successful!')
    return redirect('index')

@login_required
def coupons(request):
    coupons = Coupon.objects.filter(user=request.user)

    context = {
        'coupons': coupons,
    }

    return render(request, 'accounts/coupons.html', context)
