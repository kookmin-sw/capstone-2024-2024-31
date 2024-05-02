import torch
import numpy as np
import cv2


#미리 학습해둔 파라미터를 yolo 모델 구조에 대입
model_custom = torch.hub.load(
    "ultralytics/yolov5",
    "custom",
    path="./yolov5/best2.pt",
)

# 0은 연결되어있는 스마트폰, 1은 노트북 카메라(맥북기준)
cap = cv2.VideoCapture(0)

#q버튼 누를 때까지
while True:
    #  카메라에서 프레임 받아오기
    ret, frame = cap.read()

    # 프레임마다 이미지에서 손모양 탐지
    result = model_custom(frame)

    # 탐지한 박스 카메라 화면에 렌더링
    cv2.imshow("Real-time Classification", np.squeeze(result.render()))

    # q누르면 종료
    if cv2.waitKey(1) == ord('q'):
        break

# Release the camera and close all windows
cap.release()
cv2.destroyAllWindows()
