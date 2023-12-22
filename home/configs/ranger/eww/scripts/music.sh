#!/bin/bash
PLAYER=${2:-'mpd'}
# PLAYER='mpd'
OUT_JSON="$HOME/.config/eww/assets/music.json"
DEFAULT_ART="$HOME/.config/eww/assets/default_cover.jpg"

mkJSON() {
    local DATA=$(playerctl --player=${PLAYER} metadata -f '{{artist}}@@{{title}}@@{{lc(status)}}@@{{mpris:artUrl}}@@')
    [[ -z "${DATA}" ]] && DATA="Artista@@Titulo@@paused@@${DEFAULT_ART}@@"
    local ARTIST=$(echo "${DATA}" | awk -F '@@' '{print $1}')
    local TITLE=$(echo "${DATA}" | awk -F '@@' '{print $2}')
    local STATUS=$(echo "${DATA}" | awk -F '@@' '{print $3}')
    local COVER=$(echo "${DATA}" | awk -F '@@' '{print $4}')
    local COLOR=$(python ~/pruebas/main.py ${COVER})
    jq -n --compact-output --arg title "${TITLE}" --arg artist "${ARTIST}" --arg status "${STATUS}" --arg cover_art "${COVER}" --arg color_art "${COLOR}" --arg player "${PLAYER}" '$ARGS.named' > ${OUT_JSON}
}
getData() {
  mkJSON 2> /dev/null
  playerctl --player=${PLAYER} --follow metadata -f '@@{{status}}@@{{title}}' | while read -r _; do
    [[ "${PLAYER}" == 'firefox' ]] && sleep 0.12
    mkJSON 2> /dev/null
  done 
}
updateStatus() {
  playerctl --player=${PLAYER} --follow metadata -f '{{lc(status)}}' | while read -r STATUS; do
    cat ${OUT_JSON} | sed "s/$(jq .status ${OUT_JSON})/\"${STATUS}\"/" > ${OUT_JSON} 2> /dev/null
  done
}
if [[ ${1} == '-follow-json' ]]; then
  ps x | grep -e "playerctl --player=" -e '--follow metadata -f @@{{status}}@@{{title}}' | awk '{print $1}' | xargs kill &> /dev/null
  getData &
  tail -f -q ${OUT_JSON} 2> /dev/null
  ps x | grep -e "playerctl --player=" -e '--follow metadata -f @@{{status}}@@{{title}}' | awk '{print $1}' | xargs kill &> /dev/null
elif [[ ${1} == '-update-json' ]]; then
  ps x | grep -e "playerctl --player=" -e '--follow metadata -f @@{{status}}@@{{title}}' | awk '{print $1}' | xargs kill &> /dev/null
  getData &
  ps x | grep -e "playerctl --player=" -e '--follow metadata -f @@{{status}}@@{{title}}' | awk '{print $1}' | xargs kill &> /dev/null
else
  echo ' '
  echo '    Options:'
  echo ' '
  echo '    -follow-json PLAYER (optional) [ default player: mpd ]' 
  echo '    -update-json PLAYER (optional) [ default player: mpd ]' 
  echo ' '
fi
