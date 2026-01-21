#!/usr/bin/env sh

STATE_FILE="/tmp/waybar-power-confirm"

if [ -f "$STATE_FILE" ]; then
  rm -f "$STATE_FILE"
  systemctl poweroff
else
  touch "$STATE_FILE"
  fi

