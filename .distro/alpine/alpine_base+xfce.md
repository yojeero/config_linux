
# ================================
# Base Alpine installing
# ================================

# login to command shell
root

setup-alpine

# select a layout
us

us

# computer name
alpine-laptop

# network setup
пропускаем Enter 

# user password / If it is 6 digits, you will receive a warning, but this does not prevent installation.
1231231

# setting proxy
пропускаем Enter
 
# repository mirrors
http://mirror.ungleich.ch/mirror/packages/alpine/

# setup SSH
пропускаем Enter 

# installation location
sda

# select what the disk / system disk will be used for
sys

# disk erase request
y

reboot

# enter like root / not user ------------

pass

# install nano
apk add nano

# editing the repository file and updating
nano /etc/apk/repositories

# to access the community repository you need to uncomment the third line:
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing

# remove the # in front of it. Then press ctrl+o -> Enter -> ctrl+x.
apk update

# install sudo
apk add sudo
nano /etc/sudoers

root	ALL=(ALL:ALL) ALL
%sudo	ALL=(ALL:ALL) ALL
yopy	ALL=(ALL:ALL) ALL

# install GUI
setup-xorg-base

# ===============================
#  xfce install
# ===============================
apk add xfce4 xf86-video-fbdev xf86-video-vesa
apk add font-terminus firefox xfce4-terminal xfce4-screensaver
apk add lightdm-gtk-greeter thunar thunar-volman thunar-archive-plugin
apk add p7zip 7zip unzip tar gzip xarchiver gvfs udisks2 ntfs-3g wget git
apk add celluloid rhythmbox gnome-text-editor

# dm
setup-devd udev

rc-service lightdm start
sudo rc-update add lightdm default

# from the graphical environment we cannot shutdown, reboot or put the laptop into standby mode
sudo apk add elogind polkit-elogind

sudo reboot

# configure privilege escalation for GUI utilities
sudo rc-update add elogind default
sudo rc-service elogind start
sudo rc-service dbus start
sudo rc-update add dbus

# I usually use pulseaudio, but the developers strongly recommend pipewire
sudo addgroup apem audio
sudo addgroup apem video

sudo apk add pipewire wireplumber pipewire-pulseaudio
sudo apk add pavucontrol xfce4-pulseaudio-plugin

sudo reboot

startx

# ==============================
# LightDM to tty
# ==============================
sudo systemctl disable lightdm
sudo systemctl set-default multi-user.target
sudo systemctl enable getty@tty1.service

# in /etc/default/grub input
nomodesetв GRUB_CMDLINE_LINUX_DEFAULT 

# перегенерировать с помощью 
grub-mkconfig -o /boot/grub/grub.cfg

# ================================
# vscode / zed / librewolf  
# ================================
apk add gcompat libuser bash
apk add code-oss zed librewolf
