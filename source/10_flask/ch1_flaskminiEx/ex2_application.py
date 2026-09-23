from flask import Flask
from predict import r_model, predict_apt_price

application = Flask(__name__) # 웹어플리케이션 객체 생성

@application.route('/hello')
def handler_function():
  return "<h1>Hello, Flask!</h1>"