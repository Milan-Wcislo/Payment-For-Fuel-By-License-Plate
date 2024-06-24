# Generated by Django 5.0 on 2024-01-03 20:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gas_station', '0003_pump_fuel_amount_pump_fuel_price'),
    ]

    operations = [
        migrations.AddField(
            model_name='pump',
            name='pump_number',
            field=models.PositiveIntegerField(default=1, unique=True),
        ),
        migrations.AddField(
            model_name='tank',
            name='tank_number',
            field=models.PositiveIntegerField(default=1, unique=True),
        ),
        migrations.AlterField(
            model_name='gasstation',
            name='closing_time',
            field=models.TimeField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='gasstation',
            name='opening_time',
            field=models.TimeField(blank=True, null=True),
        ),
    ]