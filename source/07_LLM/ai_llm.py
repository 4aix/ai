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
              search_kwargs={"k": k},
              search_kwargs={"filter": filter_condition},
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