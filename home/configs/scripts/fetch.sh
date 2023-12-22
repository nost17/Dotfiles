#!/bin/bash
# Tiny colored fetch script
# Requires Typicons Font to display the icons
# elenapan @ github

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
d=$'\e[1m'
t=$'\e[0m'
# v=$'\e[7m'

k=" "
user="$USER"

r=" "
wmname="${XDG_SESSION_DESKTOP}"

sh=" "
shell=$(which "${SHELL}")

# (\ /)
# ( · ·)
# c(")(")

# (\ /)
# ( . .)
# c(")(")

tput clear
cat << EOF

   (\ /)     $f3$k  $t$user
   ( $d._.$t)    $f2$sh  $t$shell
  ${f4}c${t}| uu|     $f5$r  $t$wmname

EOF
