#!/usr/bin/env bash

SHUTDOWN=" Shutdown"
REBOOT="󰑓 Reboot"
LOGOUT="󰍃 Logout"

if [ $# -eq 0 ]; then
    echo "$SHUTDOWN"
    echo "$REBOOT"
    echo "$LOGOUT"
    exit 0
fi

case "$1" in
    *"Shutdown"*)
        systemctl poweroff
        ;;
    *"Reboot"*)
        systemctl reboot
        ;;
    *"Logout"*)
        bspc quit
        ;;
esac
