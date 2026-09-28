# 가상환경만들기 : python -m venv .venv
# 가상환경 들어가기 : .venv\Scripts\activate
# 필요한 라이브러리 : pip install statsmodels joblib flask (개별설치X)
# 필요한 라이브러리 설치 : pip install -r requirements.txt
from flask import Flask
app = Flask(__name__) # 앱 인스턴스 생성(웹서버 자체)
@app.route('/') # @데코레이터를 통해서 가능한 url등록
def main_handler():
  return '<h1>Hello world</h1>'

@app.route('/apt')
def get_apt():
  # return '<h1>예상가격은 100원입니다</h1>'
  return {
    'price':100,
    'unit':'won'
  }

# 파일명 ex1_app.py이면 실행 : flask --app ex1_app run --debug --port=80
# 서버 종료 : ctrl+C
if __name__ == '__main__':
  app.run(debug=True, port=80) # python ex1_app.py



