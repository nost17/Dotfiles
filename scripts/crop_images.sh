#!/bin/bash

ffmpeg -loglevel quiet -i "${1}" -vf "scale=400:400,crop=iw-20:140" /tmp/coversito.png -y
