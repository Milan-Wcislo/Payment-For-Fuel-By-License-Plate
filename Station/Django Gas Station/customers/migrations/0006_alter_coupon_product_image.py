# Generated by Django 5.0 on 2024-01-14 17:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('customers', '0005_rename_image_coupon_code_image_coupon_product_image'),
    ]

    operations = [
        migrations.AlterField(
            model_name='coupon',
            name='product_image',
            field=models.ImageField(default='', upload_to=''),
        ),
    ]