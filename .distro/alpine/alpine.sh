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
    xfce4 xfce4-terminal \
    firefox kitty alacritty mousepad \
    thunar thunar-archive-plugin thunar-volman \
    bottom fastfetch mc file-roller \
    p7zip unzip zip palette imv \
    ripgrep fd fzf eza imv mpv xfce4-power-manager xfce4-screenshooter \
    lxappearance xorg-xsetroot adwaita-fonts

apk add ly ly-openrc
# apk add lightdm lightdm-gtk-greeter 
# rc-update add lightdm default

sudo mkdir -p /etc/X11
echo "needs_root_rights = yes" | sudo tee /etc/X11/Xwrapper.config

nano /etc/ly/config.ini

shutdown_cmd = /sbin/poweroff
restart_cmd = /sbin/reboot
tty = 7

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
# rc-service lightdm start

# Remove your current display manager (example: lightdm)
# sudo rc-update del lightdm default

# Add Ly to start at boot
sudo rc-update add ly default

# Start Ly immediately without rebooting
sudo rc-service ly start