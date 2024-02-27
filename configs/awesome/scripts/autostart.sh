#!/bin/sh

killall mpd; mpd &
killall picom; picom -b &
nohup mpDris2 &> /dev/null &
nohup nm-applet &> /dev/null &
# /lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 
