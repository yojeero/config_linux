# login - anon, root
# pass - voidlinux

void-installer

# Void GNOME

# Update the System
sudo xbps-install -u xbps
sudo xbps-install -Suv

# Add non-free repository
sudo xbps-install -Rs void-repo-nonfree 

# Install recommended packages
sudo xbps-install curl wget git xz unzip zip nano vim gptfdisk xtools mtools mlocate ntfs-3g fuse-exfat bash-completion linux-headers gtksourceview4 ffmpeg mesa-vdpau mesa-vaapi btop kitty sushi 

# Install development packages
sudo xbps-install autoconf automake bison m4 make libtool flex meson ninja optipng sassc

# Desktop GNOME

# Install the X+DE+DM
sudo xbps-install xorg gnome gdm

# Enable gdm service
sudo ln -s /etc/sv/gdm /var/service

# Install xdg utilites
sudo xbps-install -Rs xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils dconf-editor

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

# after open Gnome desktop and use USB flash

# Audio configuration

# Install PulseAudio
sudo xbps-install pulseaudio pulseaudio-utils pulsemixer alsa-plugins-pulseaudio

# Bluetooth configuration

# Install BlueZ
sudo xbps-install bluez

# Enable Bluetooth service
sudo ln -sv /etc/sv/bluetoothd /var/service

# Add user to the group
sudo useradd -G bluetooth ${USER}

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
sudo xbps-install -Rs noto-fonts-emoji noto-fonts-ttf liberation-fonts-ttf

# Install Firefox
sudo xbps-install firefox firefox-i18n-en-US

# Set better font for Firefox
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo xbps-reconfigure -f fontconfig

# Logging Daemon activation
sudo xbps-install -Rs socklog-void
sudo ln -s /etc/sv/socklog-unix /var/service/
sudo ln -s /etc/sv/nanoklogd /var/service/

# Manage and view runit services
sudo xbps-install vsv 
