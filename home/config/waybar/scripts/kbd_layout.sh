#!/bin/zsh
setxkbmap -query | awk '/layout/ {print toupper($2)}'

