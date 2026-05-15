# --------------------------------
# 🐧 Minimal Alpine XFCE 
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

# editing the repository file and updating
nano /etc/apk/repositories
#  add
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community

apk update

adduser USERNAME
apk add sudo

nano /etc/sudoers

#Add
root ALL=(ALL:ALL) ALL
%sudo ALL=(ALL:ALL) AL
USERNAME ALL=(ALL:ALL) ALL

#3. BASIC SYSTEM

apk update
apk add \
    git curl wget \
    gvfs udisks2 ntfs-3g

#4. GRAPHICS
setup-xorg-base

#5. XFCE
apk add \
    xfce4 xfce4-terminal firefox \
    thunar thunar-archive-plugin thunar-volman \
    bottom fastfetch unzip zip ouch yazi \
    ripgrep fd fzf eza imv mpv \
    mousepad ghostty font-terminus \
    lightdm lightdm-gtk-greeter xfce4-power-manager

rc-update add lightdm default

#6. SOUND
apk add \
    pipewire pipewire-pulseaudiom \
    pavucontrol wireplumber 

# 7. SYSTEM SERVICES
rc-update add dbus default
rc-service dbus start

#8. USER GROUPS
addgroup USERNAME audio
addgroup USERNAME video
addgroup USERNAME input

#9. LAUNCHING GUI
reboot

# After loading
rc-service lightdm start