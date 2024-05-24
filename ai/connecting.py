from fastapi import FastAPI
from pydantic import BaseModel
from model import MyModel
import torch



# AI 모델의 인스턴스를 생성
model = MyModel()

# FastAPI 앱을 생성
app = FastAPI()


class PredictionRequest(BaseModel):  # 요청 바디 모델을 정의
    input_data: list


class PredictionResponse(BaseModel):  # 응답 모델을 정의
    prediction: float


# 예측 요청을 처리할 라우트를 정의
@app.post("/predict")
async def predict(request: PredictionRequest):
    # 요청에서 입력 데이터를 가져옵니다.
    input_data = torch.tensor(request.input_data)

    # AI 모델을 사용하여 예측을 수행
    prediction = model(input_data)

    # 응답 객체를 생성
    response = PredictionResponse(prediction=prediction.item())

    return response
