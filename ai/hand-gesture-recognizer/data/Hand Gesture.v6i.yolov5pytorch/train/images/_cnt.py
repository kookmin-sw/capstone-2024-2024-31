import os

directory = '/Users/chkim417/Documents/대학교/강의관련/4-1/yolov55/yolo-gesture-detection/data/Hand Gesture.v6i.yolov5pytorch/train/images'

image_count = len([name for name in os.listdir(directory) if os.path.isfile(os.path.join(directory, name))])

print(f"The number of images in the directory is: {image_count}")