#!/bin/sh
set -e

# --------------------------------
# Alpine Sway Setup Script
# --------------------------------

echo "===> Configure repositories"

cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update
apk upgrade

# --------------------------------
# Base system
# --------------------------------

echo "===> Install base packages"

apk add \
    sudo nano bash \
    dbus elogind polkit-elogind \
    seatd

# services
rc-update add dbus default
rc-update add elogind default
rc-update add seatd default

rc-service dbus start
rc-service elogind start
rc-service seatd start

# --------------------------------
# Sway / Wayland
# --------------------------------

echo "===> Install Sway environment"

apk add \
    sway swaybg swaylock swayidle \
    foot waybar fuzzel \
    wl-clipboard grim slurp \
    mako

# --------------------------------
# Filesystems / removable devices
# --------------------------------

echo "===> Install filesystem support"

apk add \
    git curl wget \
    gvfs udisks2 ntfs-3g

# --------------------------------
# Network
# --------------------------------

echo "===> Install networking"

apk add networkmanager network-manager-applet \
    wpa_supplicant

rc-update add networkmanager default
rc-service networkmanager start

# --------------------------------
# Utilities
# --------------------------------

echo "===> Install utilities"

apk add \
    thunar thunar-archive-plugin thunar-volman \
    bottom fastfetch unzip zip yazi mc \
    ripgrep eza fd fzf imv mpv zathura \
    mousepad \
    lightdm lightdm-gtk-greeter xfce4-power-manager \
    mesa mesa-dri-gallium mesa-va-gallium mesa-vdpau-gallium

# --------------------------------
# Audio (PipeWire)
# --------------------------------

echo "===> Install audio stack"

apk add \
    pipewire pipewire-pulse \
    wireplumber pavucontrol

# --------------------------------
# Fonts
# --------------------------------

echo "===> Install fonts"

apk add \
    font-noto font-terminus

# --------------------------------
# Laptop support
# --------------------------------

echo "===> Install laptop utilities"

apk add \
    brightnessctl acpi acpid

rc-update add acpid default
rc-service acpid start

# --------------------------------
# User configuration
# --------------------------------

echo "===> User setup"

printf "Enter username: "
read USERNAME

# groups
addgroup "$USERNAME" audio || true
addgroup "$USERNAME" video || true
addgroup "$USERNAME" input || true
addgroup "$USERNAME" seat || true
addgroup "$USERNAME" seatd || true
addgroup "$USERNAME" wheel || true

# sudo
if ! grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
    echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
fi

# --------------------------------
# Sway session
# --------------------------------

echo "===> Configure environment"

mkdir -p /home/"$USERNAME"/.config/environment.d

cat > /home/"$USERNAME"/.config/environment.d/wayland.conf <<EOF
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=sway
MOZ_ENABLE_WAYLAND=1
EOF

chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.config

# --------------------------------
# Done
# --------------------------------

echo
echo "# --------------------------------"
echo " Installation complete"
echo "# --------------------------------"
echo
echo "Login as user and run:"
echo
echo "    sway"
echo