from django.db import models
from django import forms
from django.core.validators import MinLengthValidator, MinValueValidator, MaxValueValidator
# Create your models here.
def min_length_2_validator(value):
  if len(value)<2:
    raise forms.ValidationError("2글자 이상 입력하세요")
  
class Book(models.Model): # 테이블명 : book_book
  # id(PK) 추가
  title = models.CharField(verbose_name="책이름", max_length=50)
  author = models.CharField(verbose_name="저자", max_length=50, 
                            validators=[min_length_2_validator,
                                      # MinLengthValidator(2, message="2글자 이상 입력하세요")
                                        ])
  publisher = models.CharField(verbose_name="출판사", max_length=50,
                              null=True, blank=True)
  sales = models.IntegerField(verbose_name="판매가", default=1000,
                              validators=[MinValueValidator(0),
                                          MaxValueValidator(100000)])
  ip = models.GenericIPAddressField(blank=True, null=True) # create한 client의 주소
  publication_date = models.DateTimeField(auto_now_add=True) # create하는 시점
  def __str__(self):
    return f"{self.id}:{self.title} - {self.author}저 {self.sales}원 - from {self.ip}"

  def get_absolute_url(self): # 수정하거나 삭제하거나 추가할 경우 갈 요청경로
    return 