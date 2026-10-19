# 실행 : streamlit run 2_streamlit.py
import streamlit as st
st.set_page_config(page_title="ai요약", page_icon="🤖")

st.title("나의 첫 streamlit 웹 애플리케이션") # h1태그
st.header("요약 어시스턴트") # h2태그
st.subheader("요약 어시스턴트는 자연어 데이터를 요약하는 것을 지원합니다.") # h3태그

st.text("text함수를 이용한 텍스트입니다.")
st.write("write 함수를 이용한 텍스트 표시입니다.")