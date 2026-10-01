### Jinja2 templates 문법
  # 1. 변수 : {{var}} 또는 {{var : filter}} 사용
    # 기본제공필터 : upper, lower, title, capitalize, trim, length, replace
    # 형변환 제공 필터 : int, float, string
  # 2. 제어문 {% %}
    # 2-1 조건문 {% if 조건1 %}태그{% elif 조건2 %}태그 {% else %}태그{% endif %}
    # 2-2 반복문
      #{% for var in 나열가능변수 %}
      #   <태그>{{loop.index}}. {{var}}</태그>
      # loop.index:1부터 순번 / loop.first:첫번째인지여부 / loop.last:마지막인지여부
      #{% endfor %}
  # 3. 해더나 풋터 {% include "header.html" %} {% extends "base.html" %}
  # 4. 서브 블럭 {% block 블럭명 %}{%endblock%}
  # 5. 주석 {# 주석 #}
from flask import Flask, render_template, request
app = Flask(__name__, static_folder='static', template_folder='templates')
lst = []

@app.route('/', methods=['GET', 'POST'])
def index(name=""):
  if request.method == 'POST':
    pass
  cnt = len(lst)
  return render_template('1_index.html',
                        name=name,
                        cnt=cnt,
                        names = lst)