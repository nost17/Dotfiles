#!/bin/bash

# ffmpeg -loglevel quiet -i "${1}" -vf "scale=400:400,crop=iw-20:140,boxblur=4" /tmp/coversito.png -y
# _HEIGHT="${2:-140}"
# ffmpeg -loglevel quiet -i "${1}" -vf "scale=400:'if(gt(iw, ih), max(400-${_HEIGHT}, ih), 400)',crop=iw:'min(${_HEIGHT}, ih)',boxblur=4" /tmp/coversito.png -y

# ffmpeg -loglevel quiet -i "${1}" -vf "scale='if(gt(iw, ih), 500, 400)':'if(gt(iw, ih), 300, 400)',crop=iw:'if(gt(iw, ih), 175, 140)',boxblur=4" /tmp/coversito.png -y

_COVER=${1}
_COVER_FINAL=/tmp/coversito.png

_OLD_W=$(identify -format "%w" ${_COVER})
_OLD_H=$(identify -format "%h" ${_COVER})
_OLD_RATIO=$(echo "scale=2; ${_OLD_W}/${_OLD_H}" | bc)

_NEW_W=${_OLD_W}
_NEW_H=${_OLD_H}
_NEW_RATIO=${2}


if [[ $(echo "$_OLD_RATIO < $_NEW_RATIO" | bc -l) ]]; then
  ffmpeg -loglevel quiet -i "${_COVER}" -vf "crop=${_NEW_W}:'ceil(${_OLD_W} * (1/${_NEW_RATIO}))',boxblur=14" ${_COVER_FINAL} -y
else
  ffmpeg -loglevel quiet -i "${_COVER}" -vf "crop='ceil(${_OLD_RATIO} * ${_NEW_RATIO})':${_NEW_H}',boxblur=14" ${_COVER_FINAL} -y
fi
