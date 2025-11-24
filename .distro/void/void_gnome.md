
# Void Linux + GNOME

# Network configuration

# Check the name of our interface
ip a

# In my case, “wlp3s0” is the name of the Wi-Fi interface.

# Create a configuration file to connect to Wi-Fi
sudo vi /etc/wpa_supplicant/wpa_supplicant-wlp3s0.conf

# Write these lines into the file and then save it
ctrl_interface=DIR=/run/wpa_supplicant
update_config=1

# Add the information about your wireless network to the file
wpa_passphrase SSID PASSWORD >> /etc/wpa_supplicant/wpa_supplicant-wlp3s0.conf

# Enable dhcpd and wpa_supplicant
sudo ln -s /etc/sv/dhcpcd /var/service
sudo ln -s /etc/sv/wpa_supplicant /var/service
sudo sv up dhcpcd
sudo sv up wpa_supplicant

# Run this command
wpa_supplicant -B -i wlp1s0 -c /etc/wpa_supplicant/wpa_supplicant-wlp3s0.conf

# To check your connection run
ping google.com

# Update the System
sudo xbps-install -u xbps
sudo xbps-install -Suv

# Add non-free repository
sudo xbps-install -Rs void-repo-nonfree 

# Install recommended packages
sudo xbps-install curl wget git xz unzip zip nano vim gptfdisk xtools mtools mlocate ntfs-3g fuse-exfat bash-completion linux-headers gtksourceview4 ffmpeg mesa-vdpau mesa-vaapi htop

# Install development packages
sudo xbps-install autoconf automake bison m4 make libtool flex meson ninja optipng sassc

# Desktop GNOME

# Install the X Window System
sudo xbps-install xorg

# Install desktop environment
sudo xbps-install gnome

# Install display manager
sudo xbps-install gdm

# Enable gdm service
sudo ln -s /etc/sv/gdm /var/service

# Install xdg utilites
sudo xbps-install -Rs xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils

# Install gnome-browser-connector
sudo xbps-install gnome-browser-connector

# Enable required services

# Install dbus
sudo xbps-install -y dbus

# Enable dbus service
sudo ln -s /etc/sv/dbus /var/service

# Install elogind
sudo xbps-install -y elogind

# Enable elogind service
sudo ln -s /etc/sv/elogind /var/service

# Network configuration

# Install Network Manager
sudo xbps-install NetworkManager NetworkManager-openvpn NetworkManager-openconnect 
NetworkManager-vpnc NetworkManager-l2tp

# Enable Network Manager service
sudo ln -sv /etc/sv/NetworkManager /var/service

# Before enabling the NetworkManager daemon, disable any other network management services, such as dhcpcd, wpa_supplicant

# Audio configuration

# Install PulseAudio
sudo xbps-install pulseaudio pulseaudio-utils pulsemixer alsa-plugins-pulseaudio

# Had some issues with pipewire, maybe will give a try in the future...

# Bluetooth configuration

# Install BlueZ
sudo xbps-install bluez

# Enable Bluetooth service
sudo ln -sv /etc/sv/bluetoothd /var/service

# Add user to the group
sudo useradd -G bluetooth ${USER}

# Printing support configuration

# Install CUPS
sudo xbps-install cups cups-pk-helper cups-filters foomatic-db foomatic-db-engine

# Enable CUPS service
sudo ln -sv /etc/sv/cupsd /var/service

# Optional

# Epson Printer
sudo xbps-install -Rs epson-inkjet-printer-escpr imagescan iscan-data
# HP Printer:
sudo xbps-install -Rs hplip-gui
# Canon Printer:
sudo xbps-install -Rs cnijfilter2
# Brother Printer:
sudo xbps-install -Rs brother-brlaser

# SANE scanner driver for brscan3-compatible Brother scanners
sudo xbps-install brother-brscan3
# SANE scanner driver for brscan4-compatible printers 
sudo xbps-install brother-brscan4 
# CUPS wrapper driver for the brother DCP-197C printer/scanner
sudo xbps-install brother-dcp197c-cupswrapper 
# LPR driver for the brother DCP-197C printer/scanner 
sudo xbps-install brother-dcp197c-lpr 

# Cron configuration

# Install cronie
sudo xbps-install -y cronie

# Enable cronie service
sudo ln -sv /etc/sv/cronie /var/service

# Notebook Power Saving configuration

# Install TLP and PowerTop
sudo xbps-install tlp tlp-rdw powertop

# Enable TLP service
sudo ln -sv /etc/sv/tlp /var/service

# Fonts installation
sudo xbps-install -Rs noto-fonts-emoji noto-fonts-ttf noto-fonts-ttf-extra

# Install LibreOffice
sudo xbps-install libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw libreoffice-math libreoffice-base libreoffice-gnome libreoffice-i18n-en-US

# Install Firefox
sudo xbps-install firefox firefox-i18n-en-US

# Set better font for Firefox
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo xbps-reconfigure -f fontconfig

# Logging Daemon activation

# By default, Void comes with no logging daemon
sudo xbps-install -Rs socklog-void
sudo ln -s /etc/sv/socklog-unix /var/service/
sudo ln -s /etc/sv/nanoklogd /var/service/

# Profile Sync Daemon

# PSD is a service that symlinks & syncs browser profile directories to RAM, thus reducing HDD/SSD calls & speeding up browsers. You can get it from here. This helps Firefox & Chromium reduce ram usage.
git clone https://github.com/madand/runit-services
cd runit-services
sudo mv psd /etc/sv/
sudo ln -s /etc/sv/psd /var/service/
sudo chmod +x etc/sv/psd/*

# Bash aliases
sudo nano ~/.bash_aliases

# Add this script
alias xu='sudo xbps-install xbps && sudo xbps-install -Suv'
alias xin='sudo xbps-install'
alias xr='sudo xbps-remove -Rcon'
alias xl='xbps-query -l'
alias xf='xl | grep'
alias xs='xbps-query -Rs'
alias xd='xbps-query -x'
alias clrk='sudo vkpurge rm all && sudo rm -rf /var/cache/xbps/*'
alias halt='sudo halt'
alias poweroff='sudo poweroff'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

# Open bash config file
sudo nano ~/.bashrc

# Add this line
if [ -f ~/.bash_aliases ]; then 
    . ~/.bash_aliases;
fi

# In the end
source ~/.bashrc

# Manage and view runit services
sudo xbps-install vsv 

# Install docker
sudo xbps-install -Su docker

# Enable required services
sudo ln -s /etc/sv/containerd /var/service
sudo ln -s /etc/sv/docker /var/service

# Add user to group
sudo groupadd docker
sudo usermod -aG docker ${USER}

# Set respective permissions
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

# Install Flatpak
sudo xbps-install -S flatpak

# Add the Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Restart

# Dconf Editor
sudo xbps-install dconf-editor

# Install Nautilus Terminal
sudo xbps-install python3 python3-pip python3-psutil nautilus-python

# Check that the extension is properly installed
nautilus-terminal --check
python3 -m nautilus_terminal --check

# If everything is OK, the output should be

# Nautilus Python: Installed
# Nautilus Terminal Extension: Installed
# To edit extension configs run
dconf-editor /org/flozz/nautilus-terminal

# Install Syncthing
sudo xbps-install -Rs syncthing 

# Starting Syncthing automatically when system starts
sudo cp /usr/share/applications/syncthing-start.desktop ~/.config/autostart/

# Gnome Sushi

# File previewer for the GNOME desktop
sudo xbps-install -Rs sushi 

# Install Intel's Microcode
sudo xbps-install -Rs intel-ucode 

# Reconfigure your kernel, according your kernel name
sudo xbps-reconfigure -f linux<kernel_version>

# To find your Linux kernel version, you can use
sudo xbps-query -l | grep linux

# Fonts, Theme, Icons, Cursor, Extensions, Wallpaper

# System Fonts

# Interface Text: Inter Regular
# Document Text: Inter Regular
# Monospace Text: JetBrains Mono Regular
# Legacy Window Titles: Inter Medium
# Terminal Font: ShureTechMono Nerd Font Mono Regular

# Extensions

AppIndicator and KStatusNotifierItem Support
Bluetooth Quick Connect
Clipboard History or Pano - Clipboard Manager (Dependencies: sudo xbps-install libgda gsound)
Color Picker
Dash to Dock
Disconnect Wifi
Easy Docker Containers
Espresso
Frippery Move Clock
Mute/Unmute
No Overview at Startup
Notification Banner Position
Printers
Resource Monitor
Sound Output Device Chooser
Status Area Horizontal Spacing
Syncthing Icon
Tiling Assistant
Toggle Night Light
Top Panel Workspace Scroll
Transparent Window Moving
Tweaks & Extensions in System Menu
User Themes
Window Is Ready - Notification Remover