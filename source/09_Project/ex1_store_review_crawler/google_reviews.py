"""
구글 리뷰 수집 (Google Places API - New, 공식)
------------------------------------------------------------
- 흐름 : 검색어로 가게 목록 찾기(Text Search) → 가게마다 상세조회(Place Details)로 리뷰 받기
- 제약 : 가게당 리뷰 최대 5개 (구글 정책, 우회 불가)
- 준비 :
   1) Google Cloud 콘솔에서 프로젝트 생성 → 결제 계정 연결
   2) 'Places API (New)' 사용 설정
   3) API 키 발급 → 환경변수 GOOGLE_API_KEY 에 저장
- 설치 : pip install requests pandas
- 출력 : google_reviews.csv (naver 코드와 같은 열 이름 'body' → Jev 분석 코드 그대로 사용 가능)
------------------------------------------------------------
"""

import os
import time

import pandas as pd
import requests
from dotenv import load_dotenv
import os
load_dotenv()

API_KEY = os.getenv('GOOGLE_PLACE_API_KEY')
QUERY = "인천 계양구 한식집"   # ← 검색어 (지역 + 업종)
MAX_PAGES = 3                # 검색 결과 페이지 수 (1페이지 = 최대 20곳)
OUT_FILE = "google_reviews.csv"


def search_places(query: str) -> list[dict]:
    """검색어로 가게 목록(id, 이름)을 가져옴. 여러 페이지면 nextPageToken으로 이어받음"""
    url = "https://places.googleapis.com/v1/places:searchText"
    headers = {
        "X-Goog-Api-Key": API_KEY,
        # FieldMask: 필요한 필드만 요청 (요금이 요청 필드에 따라 달라짐)
        "X-Goog-FieldMask": "places.id,places.displayName,nextPageToken",
    }
    body = {"textQuery": query, "languageCode": "ko"}
    places = []

    for _ in range(MAX_PAGES):
        data = requests.post(url, headers=headers, json=body, timeout=30).json()
        if "error" in data:
            raise RuntimeError(data["error"])        # 키/권한 문제면 여기서 바로 보임
        places += data.get("places", [])
        token = data.get("nextPageToken")
        if not token:
            break
        body["pageToken"] = token                   # 다음 페이지 요청
        time.sleep(2)                               # 토큰이 유효해질 때까지 잠깐 대기
    return places


def get_reviews(place_id: str) -> dict:
    """가게 하나의 평점, 리뷰 수, 리뷰(최대 5개)를 가져옴"""
    url = f"https://places.googleapis.com/v1/places/{place_id}"
    headers = {
        "X-Goog-Api-Key": API_KEY,
        "X-Goog-FieldMask": "displayName,rating,userRatingCount,reviews",
    }
    params = {"languageCode": "ko"}  # 리뷰를 한국어로 (외국어 리뷰는 번역본이 올 수 있음)
    return requests.get(url, headers=headers, params=params, timeout=30).json()


def main():
    places = search_places(QUERY)
    print(f"가게 {len(places)}곳 찾음")

    rows = []
    for p in places:
        d = get_reviews(p["id"])
        name = d.get("displayName", {}).get("text", "")
        for r in d.get("reviews", []):
            # originalText = 작성자가 쓴 원문, text = 요청 언어로 번역됐을 수 있는 버전
            original = (r.get("originalText") or r.get("text") or {}).get("text", "")
            rows.append({
                "place_name": name,
                "place_rating": d.get("rating"),           # 가게 전체 평점
                "place_total": d.get("userRatingCount"),   # 가게 전체 리뷰 수
                "rating": r.get("rating"),                 # 이 리뷰의 별점
                "body": original.replace("\n", " "),
                "published": r.get("publishTime", ""),
            })
        print(f"  {name}: {len(d.get('reviews', []))}개")
        time.sleep(0.2)

    df = pd.DataFrame(rows)
    df.to_csv(OUT_FILE, index=False, encoding="utf-8")
    print(f"[완료] 리뷰 {len(df)}개 → {OUT_FILE}")


if __name__ == "__main__":
    main()
