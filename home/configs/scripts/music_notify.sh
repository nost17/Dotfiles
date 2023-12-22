#!/bin/sh

_PLAYER=${1:-'mpd'}
_TITLE="$(playerctl --player="${_PLAYER}" metadata xesam:title)"
_ARTIST="$(playerctl --player="${_PLAYER}" metadata xesam:artist)"
_COVER="$(playerctl --player="${_PLAYER}" metadata mpris:artUrl)"
_STATUS="$(playerctl --player="${_PLAYER}" status)"
# _ACCENT="$(awesome-client "return Beautiful.blue" | awk -NF '"' '{print $2}')"

# notify-send "<span color='${_ACCENT}'><b>${_TITLE}</b></span>" "${_ARTIST}" -i "${_COVER}" -a "${_PLAYER}"
notify-send "${_TITLE}" "${_ARTIST}" -i "${_COVER}" -a "${_PLAYER}"
