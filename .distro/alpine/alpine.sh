# --------------------------------
# Alpine Sway (TTY Login)
# --------------------------------

#1. INSTALLATION

setup-alpine

keyboard: us
hostname: alpine
network: DHCP (Enter)
mirror: http://mirror.ungleich.ch/mirror/packages/alpine/
disk: sda
mode: sys
reboot

#2. USER

apk add nano

# Editing repositories
nano /etc/apk/repositories

# Add
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community

apk update

adduser USERNAME

apk add sudo

nano /etc/sudoers

# Add
root ALL=(ALL:ALL) ALL
%sudo ALL=(ALL:ALL) ALL
USERNAME ALL=(ALL:ALL) ALL

#3. BASIC SYSTEM

apk update

apk add \
    git curl wget \
    gvfs udisks2 ntfs-3g

#4. GRAPHICS

setup-xorg-base

#5. SWAY

apk add \
    sway swaybg swaylock swayidle \
    foot waybar fuzzel \
    wl-clipboard grim slurp \
    firefox mousepad \
    thunar thunar-archive-plugin thunar-volman \
    bottom fastfetch mc file-roller \
    p7zip unzip zip palette imv \
    ripgrep fd fzf eza mpv \
    xfce4-power-manager xfce4-screenshooter \
    lxappearance xorg-xsetroot \
    mesa mesa-dri-gallium mesa-va-gallium mesa-vdpau-gallium

#6. SOUND

apk add \
    pipewire pipewire-pulse \
    wireplumber \
    pavucontrol

#7. SYSTEM SERVICES

rc-update add dbus default
rc-service dbus start

# Enable PipeWire services
rc-update add seatd default
rc-service seatd start

#8. USER GROUPS

addgroup USERNAME audio
addgroup USERNAME video
addgroup USERNAME input
addgroup USERNAME seat

#9. AUTO START SWAY (TTY)

nano ~/.profile

# Add

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec sway
fi

#10. REBOOT

reboot

# Log in on tty1 and Sway will start automatically.
# Or remove ~/.profile entry and launch manually:
# sway