#!/usr/bin/env sh

STATE="/tmp/waybar-power-confirm"
TTL=2   # წამებში

if [ -f "$STATE" ]; then
  NOW=$(date +%s)
  CREATED=$(stat -c %Y "$STATE")

  if [ $((NOW - CREATED)) -le $TTL ]; then
    echo '{ "text": "YES?", "tooltip": "Click again to shutdown or Right Click to reboot", "class": "powermenu-confirm" }'
    exit 0
  else
    rm -f "$STATE"
  fi
fi

echo '{ "text": "⏻", "tooltip": "Power", "class": "powermenu" }'

