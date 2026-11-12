from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.conf import global_settings as settings
from django.contrib.auth.views import LoginView, LogoutView
# from .forms import SignupForm
from .models import Profile
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate
from django.contrib.auth.forms import AuthenticationForm
# Create your views here.
def signup(request):
  if request.method == 'POST':
    pass
  elif request.method == 'GET':
    form = UserCreationForm() # auth앱
  return render(request,
                "accounts/signup_form.html",
                {"form":form})
login = LoginView.as_view(template_name="accounts/login_form.html")
logout = LogoutView.as_view(next_page=settings.LOGIN_URL) # "/accounts/login/"