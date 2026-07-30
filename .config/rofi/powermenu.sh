#!/usr/bin/env bash

options="Shutdown\nReboot\nLogout"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme "$HOME/.config/rofi/powermenu.rasi" -no-lazy-grab)

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot)   systemctl reboot ;;
    Logout)   bspc quit ;;    
esac
