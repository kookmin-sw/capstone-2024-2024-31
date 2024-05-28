import torch
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from pathlib import Path
import cv2
from PIL import Image
import random


torch.__version__

model_custom = torch.hub.load(
    "ultralytics/yolov5", "custom", path="yolov5/runs/train/exp2/weights/last.pt"
)
# Getting all test images using .glob() based on Windows paths
TEST_DIR = Path(f"data/Hand Gesture.v6i.yolov5pytorch/test/images")
test_samples = list(TEST_DIR.glob("*.jpg"))
# Grabbing 9 random samples
random.seed(40)
random_samples = random.sample(test_samples, 9)

# Predicting the random samples
fig = plt.figure(figsize=(11, 11))
rows, cols = 3, 3
for i, sample in enumerate(random_samples):
    plt.subplot(rows, cols, i+1)
    result = model_custom(sample)
    plt.imshow(np.squeeze(result.render()))
    plt.axis(False)
