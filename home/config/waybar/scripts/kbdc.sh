#!/usr/bin/env zsh

LAYOUT=$(hyprctl devices -j | jq -r '
  .keyboards[]
  | select(.main == true)
  | .active_keymap
')

if [[ "$LAYOUT" == *"English"* ]]; then
    echo '{"text":"🇺🇸","class":"lang-en"}'
elif [[ "$LAYOUT" == *"Georgian"* ]]; then
    echo '{"text":"🇬🇪","class":"lang-ka"}'
else
    echo '{"text":"⌨","class":"lang-unknown"}'
fi
