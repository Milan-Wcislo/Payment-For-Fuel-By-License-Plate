from customers.models import LoyaltyProgram
from django.core.files.storage import FileSystemStorage
import barcode
from barcode.writer import ImageWriter
import random
from io import BytesIO

def get_loyalty_program(user):
    if user.is_authenticated:
        return LoyaltyProgram.objects.filter(customer=user).first()
    return None

def generate_coupon_code(username, product_id):
    code_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    code = f"{username}-{product_id}-"
    for i in range(0, 16):
        slice_start = random.randint(0, len(code_chars) - 1)
        code += code_chars[slice_start: slice_start + 1]
    return code

def generate_coupon_barcode(coupon_code):
    code128 = barcode.get_barcode_class('code128')
    code128_instance  = code128(coupon_code, writer=ImageWriter())

    fs = FileSystemStorage()

    storage_dir = 'barcodes/'
    filename = f"barcode_{coupon_code}.png"
    print(storage_dir)

    buffer = BytesIO()
    code128_instance.write(buffer)

    filepath = fs.save(f"{storage_dir}{filename}", buffer) 
    fs.url(filepath)

    print(filepath)
    return filepath