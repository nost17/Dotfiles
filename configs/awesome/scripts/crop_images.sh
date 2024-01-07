#!/bin/bash

# ffmpeg -loglevel quiet -i "${1}" -vf "scale=400:400,crop=iw-20:140,boxblur=4" /tmp/coversito.png -y
_HEIGHT="${2:-140}"
ffmpeg -loglevel quiet -i "${1}" -vf "scale=400:'if(gt(iw, ih), max(400-${_HEIGHT}, ih), 400)',crop=iw:'min(${_HEIGHT}, ih)',boxblur=4" /tmp/coversito.png -y

# ffmpeg -loglevel quiet -i "${1}" -vf "scale='if(gt(iw, ih), 500, 400)':'if(gt(iw, ih), 300, 400)',crop=iw:'if(gt(iw, ih), 175, 140)',boxblur=4" /tmp/coversito.png -y
