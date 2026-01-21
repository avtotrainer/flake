#!/usr/bin/env sh

STATE_FILE="/tmp/waybar-reboot-confirm"

if [ -f "$STATE_FILE" ]; then
  rm -f "$STATE_FILE"
  systemctl reboot
else
  touch "$STATE_FILE"
fi

