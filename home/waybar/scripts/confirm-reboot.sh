#!/usr/bin/env zsh

echo
echo "Reboot system?"
echo "Press ENTER to confirm, any other key to cancel."
echo

read -r key

if [[ -z "$key" ]]; then
  systemctl reboot
fi

