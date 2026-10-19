from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_upstage import ChatUpstage, UpstageEmbeddings
from pinecone import Pinecone
from langchain_pinecone import PineconeVectorStore 
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from ai_functions import (get_category, categorize_content, 
                          extract_articles_from_docs, format_documents)
import cohere
import os

load_dotenv()
OPENAI_LLM_MODEL = "gpt-4o-mini"
UPSTAGE_LLM_MODEL = "solar-pro4"
UPSTAGE_EMBEDDING_MODEL = "embedding-query" # 차원수 4096
PINECONE_INDEX_NAME = "better-rag-index"
COREHERE_API_KEY = os.getenv("COHERE_API_KEY")

# llm 생성 함수
def get_llm(model = OPENAI_LLM_MODEL):
  llm = ChatOpenAI(model_name=model)
  return llm

# 키워드 사전을 활용하여 키워드 langchain를 반환하는 함수
def get_dictionary_chain(llm):
  keyword_dict  = [
    "사람을 나타내는 표현 -> 거주자",
    "회사원 -> 근로소득이 있는 거주자",
    "연봉 -> 종합소득",
    "월급 -> 근로소득",
    "세금 -> 소득세",
    "공제받다 -> 공제를 적용받다",
    "얼마나 내야하나 -> 세액은 얼마인가",
    "계산해줘 -> 계산하면 얼마인가"
  ]
  prompt = ChatPromptTemplate.from_template(f"""사용자의 질문을 보고, 우리의 사전을 참고해서 사용자 질문을
  변경해 주세요. 만약 변경할 필요가 없을 경우, 사용자의 질문을 변경하지 않아도 됩니다. 오직 질문만 리턴해 주세요.
  사전 : {keyword_dict}
  질문 : {{question}}""")
  keyword_chain = prompt | llm | StrOutputParser()
  return keyword_chain

def get_retriever(normalized_query, model=UPSTAGE_EMBEDDING_MODEL, k=15):
  "vectorStore에서 normalized_query와 유사한 문서를 검색하는 retriver를 반환합니다."
  embedding = UpstageEmbeddings(model=model)
  vectorStore = PineconeVectorStore(
    embedding=embedding,
    index_name=PINECONE_INDEX_NAME,
  )
  filter_condition = {"category": {"$in": categorize_content(normalized_query)}}
  retriever = vectorStore.as_retriever(
              search_type="similarity",
              search_kwargs={ "k": k, "filter": filter_condition },
    )
  return retriever

# cohere의 rerank API를 사용한 documents 재정렬
def rerank_by_title(query:str, documents:list, top_k:int=3) -> list:
    '''
    cohere의 rerank API를 사용한 documents 재정렬
    Args:
    - query : 사용자 질문
    - documents : retriever로 검색된 Document 객체 list
    - top_k : 재정렬 후 반환될 문서 갯수
    Returns:
    - title 및 page_content 유사도 기준으로 재정렬된 Document list(0~top_k앞까지)
    '''
    # Document 객체에서 title과 page_content추출
    docs_text = [doc.metadata.get('title')+' '+doc.page_content for doc in documents]
    # cohere 클라이언트 객체
    co = cohere.Client(
        #api_key=COREHERE_API_KEY
        )
    # cohere rerank API 호출
    results = co.rerank(
        model = 'rerank-multilingual-v3.0', # https://docs.cohere.com/docs/rerank 참조
        query = query,
        documents=docs_text,
        top_n = top_k
    )
    # idx = [r.index for r in results.results]
    # print(idx)
    rerank_docs = [documents[r.index] for r in results.results]
    return rerank_docs

# 답변 langchain 반환
def rag_chain(llm):
  # 5. 프롬프트 템플릿
  template = f"""당신은 최고의 한국 소득세법 전문가입니다. 다음 문맥을 참고하여 질문에 답하세요. 답을 모르면 
  모른다고 답하세요.
  질문 : {{query}}
  문맥 : {{context}}
  답변 :"""
  prompt = ChatPromptTemplate.from_template(template)
  # RAG 체인 생성
  prompt_chain = prompt | llm | StrOutputParser()
  return prompt_chain

# 재사용이 가능한 함수 만들기
def ask_with_reference(query:str, chat_history:list=None, k:int=10, top_k:int=3):
  """
  query의 수정된 query, 답변, 참고조항을 반환하는 함수
  Args:
  - query : 질문
  - k : 검색할 문서의 수(기본값 : 10)
  - top_k : 재배열된 이후 사용될 문서의 수 (기본값 : 3)
  """
  # 1. LLM 초기화
  llm = get_llm()
  # ★ ★ ★ 여기에 추가
  # chat_history 에 질문이 있으면 query 재구성
  if chat_history:
      history_list = [f"{'사용자' if msg['role']=='user' else 'AI'}: {msg['content']}"  for msg in chat_history]
      history_text = "\n".join(history_list)
      # query 재구성
      rewrite_prompt = ChatPromptTemplate.from_template(
          """이전 대화를 참고하여 질문을 재구성해 주세요
          이전 대화 : {history_text}
          현재 질문 : {question}
          재구성된 질문 : """
      )
      query = (rewrite_prompt | llm | StrOutputParser()).invoke({"history_text":history_text,
                                                              "question": query})
  # ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
  # 2. 질문 표준화
  keyword_chain = get_dictionary_chain(llm)
  normalized_query = keyword_chain.invoke({"question":query})
  # retriever 생성
  retriever = get_retriever(normalized_query, k=10)
  # 문서 검색
  documents = retriever.invoke(normalized_query)
  # 재배열
  reranked_docs = rerank_by_title(query=normalized_query, documents=documents, top_k=3)
  # 참고 조항 추출
  referenced_articles = extract_articles_from_docs(reranked_docs)
  # LLM 답변 생성
  prompt_chain = rag_chain(llm)
  # 답변, 참고조항, 주의사항
  answer = prompt_chain.invoke({
                'query':normalized_query,
                'context':format_documents(reranked_docs)
            })
  result = [f"✅ 답변 : {answer}",
            f"📌 참고조항:{referenced_articles}",
            "⚠️ 위의 답변은 AI에 의해 작성된 답변이므로 약간의 차이가 날 수 있습니다"]
  return "\n\n".join(result)

if __name__ == '__main__':
  query = "연봉 5천만원인 직장인의 소득세는 얼마예요?"
  print(ask_with_reference(query, k=10, top_k=3))
