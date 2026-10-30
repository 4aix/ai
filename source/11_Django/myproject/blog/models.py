from django.db import models
import re
from django.forms import ValidationError
from django.utils import timezone
# Create your models here.

REGION_CHOICE = (
  ("Europe","유럽"),
  ("Asia", "아시아"),
  ("Oceania","오세아니아"),
  ("America","아메리카"),
)
def lnglat_validator(value):
  if not re.match(r'(\d+\.?\d*),(\d+\.?\d*)', value):
    raise ValidationError('Invalid LngLat. ex:38, 128')
  
class Post(models.Model): # 1. 테이블명 : blog_post(앱명_클래스명소문자) 2.form태그
  # id    = models.AutoField(primary_key=True) PK가 없을 경우 자동 생성
  title = models.CharField(verbose_name="제목", # form태그의 라벨
                          max_length=100,       # varchar(100) 필드로 생성
                          help_text="기사 제목입니다. 100자 내외로 입력하세요")
  content = models.TextField("본문") # CLOB타입(oracle), TEXT타입(sqlite, mysql)
  create_at = models.DateField(auto_now_add=True) # insert할 때 자동 저장
  update_at = models.DateTimeField(auto_now=True) # save()함수 수행될 때 자동 저장
  def __str__(self): # 한 레크도에 대해 작업 처리
    updated = timezone.localtime(self.update_at).strftime("%Y-%m-%d %H:%M")
    return f"{self.id}.제목:{self.title} - {self.create_at}등록. {updated}최종수정"