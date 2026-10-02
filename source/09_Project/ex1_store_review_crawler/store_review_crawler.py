"""
상가정보 + 후기 수집 예제
-------------------------------------------------
1단계) 공공데이터포털 '소상공인시장진흥공단_상가(상권)정보' API로 상가 목록 가져오기
2단계) Playwright로 리뷰 페이지를 열어 후기 수집 (셀렉터는 대상 사이트에 맞게 수정)

설치:
    pip install requests pandas playwright
    playwright install chromium

주의:
    - 대상 사이트의 이용약관과 robots.txt를 먼저 확인할 것
    - 요청 사이에 충분한 대기 시간을 둘 것 (서버 부담 방지)
    - API 주소/파라미터는 공공데이터포털 활용가이드에서 최신 내용 확인할 것
"""

import time
import random

import requests
import pandas as pd
from playwright.sync_api import sync_playwright


# =================================================
# 1단계: 공공데이터 API로 상가 기본정보 수집
# =================================================

# 공공데이터포털에서 활용신청 후 받은 인증키 (Decoding 키를 넣어야 함)
SERVICE_KEY = "kWiLqR5an3qgHfkycjPmjxAie5mGGzW0LuPktrSNA3kqpsmWfsLSW9TxR9k0khrZgJLecVcO88n5LsStz845eg=="

# 행정동 단위 상가 목록 조회 API
STORE_API_URL = "https://apis.data.go.kr/B553077/api/open/sdsc2/storeListInDong"


def fetch_stores(adong_code: str, max_pages: int = 3, rows_per_page: int = 100) -> pd.DataFrame:
    """
    행정동 코드로 해당 동의 상가 목록을 가져온다.

    adong_code   : 행정동 코드 8자리 (예: 서울 종로구 삼청동 '11110540')
                ※ 10자리 행정기관코드(1111054000)를 넣으면 NODATA가 나옴
    max_pages    : 최대 몇 페이지까지 가져올지
    rows_per_page: 한 페이지에 몇 건씩 받을지
    """
    all_items = []

    for page_no in range(1, max_pages + 1):
        params = {
            "serviceKey": SERVICE_KEY,
            "pageNo": page_no,
            "numOfRows": rows_per_page,
            "divId": "adongCd",   # 조회 기준: 행정동 코드
            "key": adong_code,    # 실제 행정동 코드 값
            "type": "json",       # 응답 형식 (기본은 xml)
        }

        res = requests.get(STORE_API_URL, params=params, timeout=10)
        res.raise_for_status()  # HTTP 오류면 예외 발생

        body = res.json().get("body", {})
        items = body.get("items", [])

        # 더 이상 데이터가 없으면 중단
        if not items:
            break

        all_items.extend(items)
        print(f"[API] {page_no}페이지: {len(items)}건 수집")

        time.sleep(0.5)  # API 과호출 방지

    df = pd.DataFrame(all_items)

    # 필요한 컬럼만 추리기 (응답에 없는 컬럼은 자동으로 제외)
    wanted = {
        "bizesNm": "상호명",
        "indsLclsNm": "업종대분류",
        "indsMclsNm": "업종중분류",
        "indsSclsNm": "업종소분류",
        "rdnmAdr": "도로명주소",
        "lon": "경도",
        "lat": "위도",
    }
    cols = [c for c in wanted if c in df.columns]
    return df[cols].rename(columns=wanted)


# =================================================
# 2단계: Playwright로 후기 수집 (템플릿)
# =================================================

# 대상 사이트의 HTML 구조에 맞게 바꿔야 하는 부분!
# 크롬 개발자도구(F12) → 후기 영역 우클릭 → '검사'로 클래스명을 확인해서 채워 넣으면 돼.
SELECTORS = {
    "review_item": "li.review_item",   # 후기 하나를 감싸는 요소
    "author": ".author",               # 작성자
    "rating": ".rating",               # 별점
    "content": ".content",             # 후기 본문
    "date": ".date",                   # 작성일
    "more_button": "button.more",      # '더보기' 버튼 (없으면 무시됨)
}


def crawl_reviews(page_url: str, store_name: str = "", max_clicks: int = 5) -> pd.DataFrame:
    """
    후기 페이지를 열어서 '더보기'를 눌러가며 후기를 모은다.

    page_url  : 후기가 있는 페이지 주소
    store_name: 결과에 함께 저장할 상호명
    max_clicks: '더보기' 버튼을 최대 몇 번 누를지
    """
    reviews = []

    with sync_playwright() as p:
        # headless=False로 바꾸면 브라우저 화면이 보여서 디버깅이 편해
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(
            user_agent=(
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/124.0 Safari/537.36"
            )
        )

        page.goto(page_url, wait_until="networkidle")

        # 참고: 후기가 iframe 안에 들어 있는 사이트라면
        #   frame = page.frame_locator("iframe#아이디")
        # 처럼 iframe을 먼저 잡고 그 안에서 셀렉터를 찾아야 해.

        # '더보기' 버튼을 반복해서 눌러 후기를 더 불러오기
        for i in range(max_clicks):
            btn = page.query_selector(SELECTORS["more_button"])
            if btn is None or not btn.is_visible():
                break
            btn.click()
            # 사람처럼 보이도록 1~2초 랜덤 대기
            page.wait_for_timeout(random.randint(1000, 2000))
            print(f"[크롤링] 더보기 {i + 1}회 클릭")

        # 화면에 로드된 후기들을 하나씩 읽기
        items = page.query_selector_all(SELECTORS["review_item"])

        for item in items:
            # 하위 요소의 텍스트를 안전하게 꺼내는 작은 도우미 함수
            def get_text(selector: str) -> str:
                el = item.query_selector(selector)
                return el.inner_text().strip() if el else ""

            reviews.append({
                "상호명": store_name,
                "작성자": get_text(SELECTORS["author"]),
                "별점": get_text(SELECTORS["rating"]),
                "내용": get_text(SELECTORS["content"]),
                "작성일": get_text(SELECTORS["date"]),
            })

        browser.close()

    print(f"[크롤링] {store_name or page_url}: 후기 {len(reviews)}건 수집")
    return pd.DataFrame(reviews)


# =================================================
# 실행 예시
# =================================================
if __name__ == "__main__":
    # 1) 상가 목록 수집 → CSV 저장
    #    행정동코드는 8자리! (테스트에서 확인된 삼청동 코드 사용)
    stores = fetch_stores(adong_code="11110540", max_pages=2)
    stores.to_csv("stores.csv", index=False, encoding="utf-8-sig")
    print(stores.head())