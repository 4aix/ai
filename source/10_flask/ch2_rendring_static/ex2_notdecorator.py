def hello():
  print(hello.__name__, '함수 전처리')
  print('hello')
  print(hello.__name__, '함수 후처리')

def world():
  print(world.__name__, '함수 전처리')
  print('world')
  print(world.__name__, '함수 후처리')

if __name__=='__main__':
  hello()
  world()