# Generated by Django 5.0 on 2024-01-23 09:45

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('gas_station', '0006_rename_createdtransaction_transactioninproccess'),
    ]

    operations = [
        migrations.RenameField(
            model_name='transaction',
            old_name='gas_station',
            new_name='pump',
        ),
        migrations.RenameField(
            model_name='transactioninproccess',
            old_name='gas_station',
            new_name='pump',
        ),
    ]
