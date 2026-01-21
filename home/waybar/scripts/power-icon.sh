#!/usr/bin/env zsh

STATE="/tmp/waybar-power-confirm"

if [ -f "$STATE" ]; then
  echo '{ "text": "YES?", "tooltip": "Click again to shutdown", "class": "powermenu-confirm" }'
else
  echo '{ "text": "⏻", "tooltip": "Power", "class": "powermenu" }'
fi

# echo '{ "text": "⏻", "tooltip": "Power Menu", "class": "powermenu" }'
