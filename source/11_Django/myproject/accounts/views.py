from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.conf import global_settings as settings
from django.contrib.auth.views import LoginView, LogoutView
from .forms import SignupForm
from .models import Profile
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate
from django.contrib.auth.forms import AuthenticationForm
# Create your views here.
def signup(request):
  if request.method == 'POST':
    form = SignupForm(request.POST)
    # print('유효한지 아닌지 :',form.is_valid())
    if form.is_valid():
      profile = form.save() # DB저장
      # 회원가입 후 로그인 페이지로 가기(로그인 페이지에서 가입한 username을 보이기)
      request.session["username"] = profile.user.username
      # return redirect("/accounts/login") : 하드코딩
      return redirect(settings.LOGIN_URL)
  elif request.method == 'GET':
    #form = UserCreationForm() # auth앱
    form = SignupForm()
  return render(request,
                "accounts/signup_form.html",
                {"form":form})
login = LoginView.as_view(template_name="accounts/login_form.html")
class ArticleLoginView(LoginView):
  template_name="accounts/login_form.html"
  def get_initial(self):
    initial =  super().get_initial()
    username = self.request.session.pop("username", None) # 회원가입 후 로그인 할 경우만 username
    if username:
      initial["username"] = username
    return initial  
custom_login = ArticleLoginView.as_view()
logout = LogoutView.as_view(next_page=settings.LOGIN_URL) # "/accounts/login/"
# 로그인 하였을 경우만 실행. 비로그인 상태에서는 로그인 페이지로
@login_required
def profile(request):
  profile, created = Profile.objects.get_or_create(
    user=request.user 
    # profile에 있는 user이면 created에 False/profile에는 없고, user에만 있으면 created에 True
    )
  return render(request, "accounts/profile.html",
                {"profile":profile,
                # "user":request.user,
                "is_new_profile":created})