from flask import Flask
from predict import r_model, predict_apt_price

application = Flask(__name__) # 웹어플리케이션 객체 생성

@application.route('/hello')
def handler_function():
  return "<h1>Hello, Flask!</h1>"

if __name__=='__main__':
  # debug=True : 코드가 변경될 때마다 자동 서버 재시작
  application.run(debug=True, port=80)