#!/usr/bin/env bash

NO_FORMAT="\e[0m"
C_RED="\e[38;5;9m"
C_BLUE="\e[38;5;12m"
C_GREEN="\e[38;5;2m"
F_BOLD="\e[1m"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_TARGET_DIR=$HOME/.config
DATA_JSON=${SCRIPT_DIR}/data_install.jsonc

getPrompt() {
  local F_UNDERLINED="\e[4m"
  local F_DIM="\e[2m"
  sleep 0.4;
  echo -e "\n${F_DIM}[[${NO_FORMAT} ${F_BOLD}${C_GREEN}${1}${NO_FORMAT} ${F_DIM}]]${NO_FORMAT}\n"
  sleep 0.4;
}

readarray -t CONFIG_LIST < <(cat ${DATA_JSON} | jq -c '.configs[]' | awk -NF '"' '{print $2}')
readarray -t INSTALL_LIST < <(cat ${DATA_JSON} | jq -c '.install[]' | awk -NF '"' '{print $2}')

clear

sleep 0.3
echo -e "\n [${C_RED}+${NO_FORMAT}] DOTFILES :: Welcome, init script..."

getPrompt "INSTALLING PROGRAMS"
echo -e " [${C_RED}+${NO_FORMAT}] Installing :: ${INSTALL_LIST[@]}"

getPrompt "INSTALLING CONFIG FILES"
for config_file in ${CONFIG_LIST[@]}; do
  echo -e " [${C_RED}+${NO_FORMAT}] Symlink:: ${config_file} ${C_BLUE}-->${NO_FORMAT} ${CONFIG_TARGET_DIR}/${config_file}"
  if [ -d "${CONFIG_TARGET_DIR}/${config_file}" ]; then rm "${CONFIG_TARGET_DIR}/${config_file}"; fi
  ln -s "${SCRIPT_DIR}/configs/${config_file}" "${CONFIG_TARGET_DIR}/${config_file}"
  sleep 0.2
done
echo ""

# echo ${CONFIG_LIST[@]}
# echo ${MILISTA[@]}
