# https://developers.google.com/maps/documentation/places/web-service?utm_source=chatgpt.com&hl=ko

'''
Google Cloud Console로 들어가서 프로젝트 생성  
그 프로젝트에 결제 계정(Billing) 연결  
Places API (New) 활성화  
API Key 생성  
가게 이름으로 먼저 검색해서 place_id를 얻기  
그 place_id로 https://places.googleapis.com/v1/places/{place_id}
'''

import requests

API_KEY = "AIzaSyCoHUFjVfB3pY6zEZqTXuPUkBDnLQNvsgw"
place_id = "ChIJqyhEBr-ffDUR4h_3EsvTtlQ"

url = f"https://places.googleapis.com/v1/places/{place_id}"

headers = {
    "X-Goog-Api-Key": API_KEY,
    "X-Goog-FieldMask": "displayName,rating,userRatingCount,reviews"
}

data = requests.get(url, headers=headers).json()

for review in data.get("reviews", []):
    print(review)