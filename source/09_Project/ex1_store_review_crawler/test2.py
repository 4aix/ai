import requests

SERVICE_KEY = "kWiLqR5an3qgHfkycjPmjxAie5mGGzW0LuPktrSNA3kqpsmWfsLSW9TxR9k0khrZgJLecVcO88n5LsStz845eg==".strip()   # 실제 키로 바꿔서 실행
URL = "https://apis.data.go.kr/B553077/api/open/sdsc2/storeListInDong"

params = {
    "serviceKey": SERVICE_KEY,
    "pageNo": 1,
    "numOfRows": 20,
    "divId": "signguCd",   # 조회 기준을 '시군구 코드'로 변경
    "key": "11110",        # 서울 종로구 시군구 코드 (5자리)
    "type": "json",
}

res = requests.get(URL, params=params, timeout=10)
data = res.json()

# 결과 코드 확인 (00이면 정상)
header = data.get("header", {})
print("resultCode:", header.get("resultCode"), header.get("resultMsg"))

# 상가 목록에서 행정동코드/행정동명만 뽑아서 중복 없이 출력
items = data.get("body", {}).get("items", [])
dongs = {(it.get("adongCd"), it.get("adongNm")) for it in items}

print(f"상가 {len(items)}건 조회됨")
for code, name in sorted(dongs):
    print(code, name)   # 여기 나온 코드가 이 API에서 쓰는 '진짜' 행정동코드