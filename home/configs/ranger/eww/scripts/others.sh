#!/bin/bash

getDate() {
  local DAY=$(date +'%A')
  local DATE=$(date +'%d %B, %Y')
  if [[ $1 == '--date' ]]; then echo "${DATE^}" && exit ;fi
  echo "${DAY^}"
}
getDate $1
