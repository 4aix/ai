# 파일명 app.py => if문 없이 flask run --debug --port 80
from flask import Flask, render_template, request
from filters import mask_comma, mask_password
from models import Member

app = Flask(__name__)
app.template_filter("mask_pw")(mask_password)
app.template_filter("comma")(mask_comma)

@app.errorhandler(404)
def errorhandler(error):
  print(error)
  return render_template('error_page.html'), 404 # 404를 넘기지 않으면 정상페이지인식

@app.route('/', methods=['GET'])
def index():
  return render_template('2_crud/index.html')