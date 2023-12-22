#!/bin/bash

toggleMenu () {
  if [[ "$(eww get 'MENU_EXTRA_VISIBLE')" == 'false' ]]; then
    eww update 'MENU_EXTRA_VISIBLE=true'
  else
    eww update 'MENU_EXTRA_VISIBLE=false'
  fi
}
changeContent () {
  if [[ "${1}" == 'notify' ]]; then
    local OPT1=$(jq -n --arg icon "﬇" --arg action "kitty" --arg name "notify dnd" --arg status "disable" '$ARGS.named' )
    local OPT2=$(jq -n --arg icon "﬈" --arg action "alacritty" --arg name "notify silent" --arg status "disable" '$ARGS.named' )
    local OPT3=$(jq -n --arg icon "ﬂ" --arg action "thunar" --arg name "notify normal" --arg status "disable" '$ARGS.named' )
    jq -n --compact-output --argjson options "[${OPT1}, ${OPT2}, ${OPT3}]" '$ARGS.named' > ~/.config/eww/assets/out.json
  fi
  toggleMenu
}
if [[ "${1}" == '-toggle' ]]; then
  changeContent "${2}"
else
  echo "Elige una opcion"
fi
