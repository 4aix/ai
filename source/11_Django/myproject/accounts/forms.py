from django.contrib.auth.forms import UserCreationForm
from django import forms
from .models import Profile
class SignupForm(UserCreationForm):
  phone_number = forms.CharField(label="전화", max_length=20)
  address      = forms.CharField(label="주소", max_length=100)