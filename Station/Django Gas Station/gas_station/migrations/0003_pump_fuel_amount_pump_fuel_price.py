# Generated by Django 5.0 on 2024-01-03 20:10

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gas_station', '0002_systemcontroller_last_updated'),
    ]

    operations = [
        migrations.AddField(
            model_name='pump',
            name='fuel_amount',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=10),
        ),
        migrations.AddField(
            model_name='pump',
            name='fuel_price',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=10),
        ),
    ]