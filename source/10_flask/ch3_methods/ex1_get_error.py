# 가상환경 생성 방법1 : python -m venv .venv
# 가상환경 생성 방법2 : ctrl+shift+p => select interpreter입력 => 가상환경만들기 => .venv로 가상환경만들기
# 라이브러리 설치 : pip install flask pydantic(ctrl+j 터미널)
# pip freeze > requirements.txt
'''URL을 통해서 데이터 전달하는 방식
- 쿼리스트링 : CRUD중 C, R
    /apt?year=2002
- 경로파라미터 : CRUD중 U, D => REST API방식
    /apt/2002
'''
from flask import (Flask,         # 앱 객체
                  render_template,# html 랜더링
                  request,        # GET/POST방식으로 파라미터 받기
                  abort)          # 강제로 예외발생

app = Flask(__name__)

@app.route('/')
def index():
  return render_template('1_get/index.html') #templates/1_get/index.html

@app.route('/user', methods=['GET']) # /user?name=홍 (쿼리스트링)
def user():
  print(request.args)
  return 'TEST'

if __name__=='__main__':
  app.run(debug=True, port=80)