from openai import OpenAI
def askGPT(message):
  'GPT모델에게 요청하여 message를 요약한 결과를 반환합니다.'
  client = OpenAI()
  response = client.chat.completions.create(
    model="gpt-4.1-mini",
    messages=[
      {
        'role':'system', 
        'content':'당신은 한국어로 된 텍스트를 잘 요약하는 전문 어시스턴트입니다'
      },
      {
        'role':'user',
        'content':f'''다음의 text를 한줄로 요약하세요. 글머리표를 사용하세요.
        text : {message}'''
      }
    ]
  )
  return response.choices[0].message.content