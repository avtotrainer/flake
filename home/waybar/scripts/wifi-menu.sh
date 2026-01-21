#!/usr/bin/env bash



chosen=$(nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL dev wifi list | \
  sed 's/^*://' | \
  rofi -dmenu -p "Select Wi-Fi")

[ -z "$chosen" ] && exit

ssid=$(echo "$chosen" | cut -d: -f1)
security=$(echo "$chosen" | cut -d: -f2)

if [[ "$security" == "--" ]]; then
  nmcli dev wifi connect "$ssid"
else
  pass=$(rofi -dmenu -password -p "Password for $ssid")
  [ -z "$pass" ] && exit
  nmcli dev wifi connect "$ssid" password "$pass"
fi

