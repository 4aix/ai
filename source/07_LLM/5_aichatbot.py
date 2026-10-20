import streamlit as st
from ai_llm import ask_with_reference

st.set_page_config(page_title="소득세법 쳇봇", page_icon="💰")
st.title("소득세법 쳇봇")
st.caption("소득세 관련된 질문을 답변 드립니다")

# 저장될 대화 이력 초기화
if 'messages' not in st.session_state:
  st.session_state.messages = []
# 이전 대화 출력
for msg in st.session_state.messages:
  st.chat_message(msg['role']).write(msg['content'])

if user_question := st.chat_input(placeholder="소득세 관련 질문을 입력하세요"):
  with st.chat_message("user"):
    st.write(user_question) 
    st.session_state.messages.append({"role":"user", "content":user_question})
  with st.spinner("질문을 처리하는 중입니다..."):
    answer = ask_with_reference(user_question, chat_history=st.session_state.messages[:-1])
    st.chat_message("ai").write(answer)
    st.session_state.messages.append({"role":"ai", "content":answer})