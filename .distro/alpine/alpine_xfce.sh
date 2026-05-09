install-xfce.sh#!/bin/sh

set -e

echo "===> Updating repositories"

cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update
apk upgrade

echo "===> Installing base packages"
apk add sudo nano bash

echo "===> Installing Xorg"
setup-xorg-base

echo "===> Installing XFCE and apps"
apk add xfce4 xfce4-terminal xfce4-screensaver
apk add lightdm lightdm-gtk-greeter
apk add thunar thunar-volman thunar-archive-plugin
apk add firefox font-terminus
apk add xf86-video-vesa xf86-video-fbdev
apk add gvfs udisks2 ntfs-3g
apk add wget git tar gzip 7zip 
apk add celluloid rhythmbox xed

echo "===> Installing elogind + dbus"
apk add elogind polkit-elogind dbus

rc-update add elogind default
rc-update add dbus default

rc-service elogind start
rc-service dbus start

echo "===> Installing audio (PipeWire)"
apk add pipewire wireplumber pipewire-pulseaudio \
    pavucontrol xfce4-pulseaudio-plugin

echo "===> Enabling display manager"
rc-update add lightdm default

echo "===> Adding user to groups"

read -p "Enter username: " USERNAME

addgroup "$USERNAME" audio || true
addgroup "$USERNAME" video || true
addgroup "$USERNAME" input || true

echo "===> Enabling sudo for user"

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
addgroup "$USERNAME" wheel

echo "===> Done!"
echo "Reboot the system with: reboot"