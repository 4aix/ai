from django.shortcuts import render, redirect, reverse,  get_object_or_404
from django.views.generic import CreateView, ListView, UpdateView, DeleteView
from django.urls import reverse_lazy
# from .forms import BookForm, BookModelForm
from .models import Book
# 1. form없이 걍 2. form객체생성후(6장) 3. DjangoGenericView 이용(7장) 4. GenericView 상속(7장)
# def book_list(request):
#   return render(request, "book/book_list.html",
#                   {"book_list": Book.objects.all(),
#                   "object_list" : Book.objects.all()})

book_list = ListView.as_view(model=Book)

def book_new(request):
  # GET : template페이지(book/book_form.html ; book을 입력받는 페이지)로 응답
  # POST 