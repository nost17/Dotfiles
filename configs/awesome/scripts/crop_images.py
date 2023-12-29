# Importing Image class from PIL module
from PIL import Image
import sys

def notArgs():
    print("not image")
    quit()

image_path = sys.argv[1].replace('file://', '') if len(sys.argv) > 1 else notArgs()

image_file = Image.open(r"{}".format(image_path))

image_width, image_height = image_file.size
newSize = image_height / 3 if image_width > image_height else image_height/6

left = 0
right = image_width 
top = (image_height / 2) - newSize
bottom = (image_height / 2) + newSize

newImage = image_file.crop((left, top, right, bottom))
# image_file.show()
newImage = newImage.save("/tmp/coversito.png")
