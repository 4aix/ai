# api_test.py : API 응답을 그대로 출력해서 원인 확인하기
import requests

SERVICE_KEY = "kWiLqR5an3qgHfkycjPmjxAie5mGGzW0LuPktrSNA3kqpsmWfsLSW9TxR9k0khrZgJLecVcO88n5LsStz845eg==".strip()
URL = "https://apis.data.go.kr/B553077/api/open/sdsc2/storeListInDong"

params = {
    "serviceKey": SERVICE_KEY,
    "pageNo": 1,
    "numOfRows": 10,
    "divId": "adongCd",
    "key": "1111051500",
    "type": "json",
}

res = requests.get(URL, params=params, timeout=10)

# 1) HTTP 상태 코드 (200이면 통신 자체는 성공)
print("상태코드:", res.status_code)

# 2) 실제로 요청된 주소 (키가 %253D 처럼 이중 인코딩됐는지 확인용)
#    키 전체가 화면에 찍히지 않도록 앞부분만 출력
print("요청 URL:", res.url[:150], "...")

# 3) 서버가 보낸 응답 원문 앞부분 (여기에 오류 메시지가 들어 있음)
print("응답 내용:")
print(res.text[:800])