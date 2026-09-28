# 데코레이터 : 플라스크를 포함해 다른 오픈소스 코드에 @로 시작하는 구문
# 대상함수를 감싸 함수 앞뒤에 부가적으로 반복작업을 사용
def check(func):
  def wrapper():
    print(func.__name__, '함수 전처리')
    func()
    print(func.__name__, '함수 후처리')
  return wrapper
@check
def hello():
  print('hello')
@check
def world():
  print('world')

if __name__=='__main__':
  hello()
  world()