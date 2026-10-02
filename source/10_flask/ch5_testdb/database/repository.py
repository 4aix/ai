# emp들 목록가져오기, emp 한행의 상세보기
from database.connection import conn
from typing import List # 타입체크용

def get_emp_list() -> List[dict]:
  'emp테이블의 내용을 dict list로 return'
  cursor = conn.cursor()
  sql = "SELECT * FROM EMP"
  cursor.execute(sql)
  emps = cursor.fetchall()
  keys = [desc[0].lower() for desc in cursor.description]
  emp_list = [dict(zip(keys, emp)) for emp in emps]
  cursor.close()
  return emp_list # 딕셔너리 리스트

def get_emp(empno:int) -> dict :
  '매개변수로 사번을 입력받아 해당 사번의 데이터를 dict로 return'
  cursor = conn.cursor()
  sql = "SELECT * FROM EMP WHERE EMPNO = :empno"
  cursor.execute(sql, {'empno':empno})
  emp = cursor.fetchone() # 튜플
  keys = [desc[0].lower() for desc in cursor.description]
  emp_dict = dict(zip(keys, emp))
  cursor.close()
  return emp_dict
# 파일 실행방법 : ctrl+j : python -m database.repository
if __name__=="__main__":
  emp_list = get_emp_list()
  print(emp_list)
  emp = get_emp(7876)
  print(emp)