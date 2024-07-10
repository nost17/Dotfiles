#!/usr/bin/bash

notificaciones() {
  notify-send uno
  # sleep 1
  notify-send dos
  # sleep 1
  notify-send tres
  # sleep 1
  notify-send cuatro
}

notificaciones &

_CONTADOR=0
_CONTADOR_TOTAL=0
while true; do
  if [ $_CONTADOR -eq 4 ]; then
    _CONTADOR=1
    _CONTADOR_TOTAL=$((_CONTADOR_TOTAL+4))
    echo "$_CONTADOR: $_CONTADOR_TOTAL"
  else
    _CONTADOR=$((_CONTADOR+1))
    echo "$_CONTADOR"
  fi
  sleep 1
done
