

# ================================
# Base Alpine installation
# ================================

# log in as root
root

setup-alpine

# select a layout
us

us

# computer name
alpine-laptop

# network setup
press Enter to skip

# user password / If it is 6 digits, you will receive a warning, but this does not prevent installation.
1231231

# setting proxy
press Enter to skip
 
# repository mirrors
http://mirror.ungleich.ch/mirror/packages/alpine/

# setup SSH
press Enter to skip (no SSH server)

# installation location
sda

# select how the disk will be used
sys

# disk erase request
y

reboot

# log in as root (not as a user)
pass

# install nano
apk add nano

# editing the repository file and updating
nano /etc/apk/repositories

# to access the community repository
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community

# https://dl-cdn.alpinelinux.org/alpine/edge/main
# https://dl-cdn.alpinelinux.org/alpine/edge/community
# https://dl-cdn.alpinelinux.org/alpine/edge/testing

# remove the # in front of it. Then press ctrl+o -> Enter -> ctrl+x.
apk update

# add user
adduser USERNAME

# install sudo
apk add sudo
nano /etc/sudoers

root	  ALL=(ALL:ALL) ALL
%sudo	  ALL=(ALL:ALL) ALL
USERNAME  ALL=(ALL:ALL) ALL

# install GUI
setup-xorg-base

# ===============================
#  xfce install
# ===============================
apk add foot fastfetch mousepad firefox lf vifm micro 

# apk add thunar thunar-archive-plugin thunar-volman
apk add yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

apk add xfce4 xf86-video-fbdev xf86-video-vesa 
apk add tar gzip gvfs udisks2 ntfs-3g wget git
apk add font-terminus xfce4-terminal xfce4-screensaver lightdm-gtk-greeter
apk add celluloid rhythmbox 

rc-service lightdm start
sudo rc-update add lightdm default

# from the graphical environment we cannot shutdown, reboot or put the laptop into standby mode
sudo apk add elogind polkit-elogind

sudo reboot

# configure privilege escalation for GUI utilities
sudo rc-update add elogind default
sudo rc-service elogind start
sudo rc-service dbus start
rc-update add dbus default

# I usually use pulseaudio, but the developers strongly recommend pipewire
addgroup USERNAME audio
addgroup USERNAME video

sudo apk add pipewire wireplumber pipewire-pulseaudio
sudo apk add pavucontrol xfce4-pulseaudio-plugin

sudo reboot

rc-service lightdm start

# startx