#!/usr/bin/env sh

STATE="/tmp/waybar-power-confirm"
TTL=2

if [ -f "$STATE" ]; then
  NOW=$(date +%s)
  CREATED=$(stat -c %Y "$STATE")

  if [ $((NOW - CREATED)) -le $TTL ]; then
    rm -f "$STATE"
    systemctl poweroff
    exit 0
  else
    rm -f "$STATE"
  fi
fi

touch "$STATE"

