#!/bin/bash


if [[ "${1}" == '-e' ]]; then
  if [[ "${2}" == 'launcher' ]]; then
    rofi -show drun &
  fi
else
  exec "$@" &
fi