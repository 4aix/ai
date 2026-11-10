import os.path
from django.db import models
from django.urls import reverse
from myproject import settings
from django.shortcuts import get_object_or_404
STATUS_CHOICES = (
  ('d', 'Draft'),
  ('p', 'Published'),
  ('w', 'Withdrawn'),
)
class Article(models.Model): # 테이블명 : article_article
  # id = models.AutoField(primary_key=True)
  title = models.CharField(verbose_name="제목", max_length=100) # input
  body = models.TextField(verbose_name="본문") # textarea
  status = models.CharField(max_length=1, choices=STATUS_CHOICES) # select
  # photo(이미지 파일 첨부) : pip install pillow -> pip freeze > requirements.txt
  photo = models.ImageField(verbose_name="사진",
                          blank=True, # _media/파일 자동 저장
                          upload_to="article/%Y/%m/%d") # _media/article/2026/11/10/파일
  def __str__(self):
    return f"{self.id}. {self.title}"

  def get_absolute_url(self):
    # return reverse("article:list") # create, update후 url
    return reverse("article:detail", args=[self.id]) # create, update후 url 해당기사 상세보기
                                                # /article/1/detail