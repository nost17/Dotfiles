#!/bin/bash

_PLAYER=${1:-'mpd'}

playerctl -p ${_PLAYER} metadata -F | grep --line-buffered "title" | while read -r _ ; do
  notify-send "$(playerctl -p ${_PLAYER} metadata xesam:artist)" \
    "~ $(playerctl -p ${_PLAYER} metadata xesam:title)" \
    -i "$(playerctl -p ${_PLAYER} metadata mpris:artUrl)"
done
