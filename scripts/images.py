# Importing Image class from PIL module
from PIL import Image
import sys

def notArgs():
    print("not image")
    quit()

image_path = sys.argv[1].replace('file://', '') if len(sys.argv) > 1 else notArgs()

image_file = Image.open(r"{}".format(image_path))

im_width, im_height = image_file.size
height_multiplier = 4.1 if im_width > im_height else 3

left = 0
top = im_height / 2.55
bottom = height_multiplier * im_height / 4
right = bottom * top
new_image = image_file.crop((left, top, right, bottom))
# new_image.show()
# image_file.show()
new_image = new_image.save("/tmp/coversito.png")
