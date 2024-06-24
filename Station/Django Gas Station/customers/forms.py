from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django import forms

from .models import Vehicle


class CreateUserForm(UserCreationForm):
    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']

    def __init__(self, *args, **kwargs):
        super(CreateUserForm, self).__init__(*args, **kwargs)
        self.fields["username"].widget.attrs.update({"placeholder": "Username"})
        self.fields["email"].widget.attrs.update({"placeholder": "Email"})
        self.fields["password1"].widget.attrs.update({"placeholder": "Password"})
        self.fields["password2"].widget.attrs.update({"placeholder": "Confirm Password"})

        for visible in self.visible_fields():
            visible.field.widget.attrs['class'] = 'form-control'


class CreateVehicleForm(forms.ModelForm):
    class Meta:
        model = Vehicle
        fields = ['license_plate', 'engine_type', 'brand', 'model']

    def __init__(self, *args, **kwargs):
        super(CreateVehicleForm, self).__init__(*args, **kwargs)
        self.fields["license_plate"].widget.attrs.update({"placeholder": "License_plate"})
        self.fields["engine_type"].widget.attrs.update({"placeholder": "Engine_type"})
        self.fields["brand"].widget.attrs.update({"placeholder": "Brand"})
        self.fields["model"].widget.attrs.update({"placeholder": "Model"})

        for visible in self.visible_fields():
            visible.field.widget.attrs['class'] = 'form-control'
    