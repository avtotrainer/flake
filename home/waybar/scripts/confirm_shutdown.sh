#!/bin/zsh

echo '{ "text": "⏻", "tooltip": "Power Menu", "class": "powermenu" }'
read -r -n 1 key
if [[$key==$'\x0a' ]]; then
  systemctl poweroff
  fi
