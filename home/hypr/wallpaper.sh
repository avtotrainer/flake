#!/usr/bin/env sh
set -e

LOG="$XDG_CACHE_HOME/hypr/wallpaper.log"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1

swww init || true
swww img "$HOME/Pictures/wallpapers/default.jpg"

