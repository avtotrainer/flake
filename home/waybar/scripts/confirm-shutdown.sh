#!/usr/bin/env zsh


echo
echo "Power off system?"
echo "Press ENTER to confirm, any other key to cancel."
echo

read -r key

# ENTER = ცარიელი სტრიქონი
if [[ -z "$key" ]]; then
  systemctl poweroff
fi
