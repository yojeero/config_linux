#!/bin/sh
set -e

echo "===> Repositories"
cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update
apk upgrade

echo "===> Base system"
apk add sudo nano bash seatd dbus elogind polkit-elogind

rc-update add dbus default
rc-update add elogind default
rc-update add seatd default

rc-service dbus start
rc-service elogind start
rc-service seatd start

echo "===> Sway + Wayland stack"
apk add sway swaybg swaylock swayidle \
    foot waybar wofi \
    wl-clipboard grim slurp \
    mako

echo "===> Filesystem & devices"
apk add gvfs udisks2 ntfs-3g

echo "===> Network & utils"
apk add networkmanager network-manager-applet \
    wireless-tools wpa_supplicant \
    curl wget git htop neofetch

rc-update add networkmanager default
rc-service networkmanager start

echo "===> Audio (PipeWire)"
apk add pipewire wireplumber pipewire-pulse \
    pavucontrol

echo "===> Fonts"
apk add font-noto font-noto-cjk font-noto-emoji

echo "===> Laptop tweaks"
apk add brightnessctl acpi acpid

rc-update add acpid default
rc-service acpid start

echo "===> User setup"
read -p "Enter username: " USERNAME

addgroup "$USERNAME" video || true
addgroup "$USERNAME" audio || true
addgroup "$USERNAME" input || true
addgroup "$USERNAME" seat || true

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
addgroup "$USERNAME" wheel

echo "===> Enable seatd for user"
addgroup "$USERNAME" seatd || true

echo "===> Done"
echo "Login as user and run: sway"