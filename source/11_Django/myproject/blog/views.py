from django.shortcuts import render, redirect, get_object_or_404
from .models import Post
from django.contrib import messages
# Create your views here.
def list(request):
  post_list = Post.objects.all()
  return render(request, 
                "blog/index.html",
                {"post_list":post_list,
                # "user":request.user : context_processors.request역할
                })

def detail(request, post_id:int):
  pass