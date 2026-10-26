from django.shortcuts import render

# Create your views here.
def wordinput(request):
  return render(request, "wordcnt/wordinput.html")

def about(request):
  pass

def result(request):
  pass