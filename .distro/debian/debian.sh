#!/bin/bash

# clean GNOME
sudo apt autoremove -y \
    yelp evolution thunderbird gnome-tour \
    gnome-software gnome-sushi gnome-characters gnome-maps gnome-contacts \
    libreoffice libreoffice-common \
    gnome-klotski gnome-mahjong gnome-chess gnome-games gnome-mines \
    gnome-nibbles gnome-robots gnome-sudoku gnome-taquin gnome-tetravex \
    gnome-2048 swell-foop aisleriot \
    gnome-weather shotwell xfburn xfce4-dict

# pkgs
sudo apt update
sudo apt install -y \
            firefox kitty ghostty \
            nautilus file-roller yazi \
            mousepad fastfetch bottom \
            zip unzip p7zip unrar ouch \
            wget git curl gvfs udisks2 ntfs-3g \
            xdg-utils glib ripgrep zoxide \
            celluloid rhythmbox imagemagick ffmpeg \
            adwaita-icon-theme mint-y-icons

# SHELL
sudo apt install -y fish eza fzf fd

chsh -s $(command -v fish)

# ubuntu look
sudo apt install -y \
            plymouth ecryptfs-utils python-is-python3 binutils \
            fonts-noto-core fonts-hack \
            gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions \
            gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock \
            gnome-shell-extension-appindicator gnome-shell-extension-system-monitor \
            yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound \
            yaru-theme-unity gnome-package-updater gnome-packagekit

# BSPWM
sudo apt install -y bspwm sxhkd rofi picom polybar

# repo+system
sudo apt-add-repository -y non-free contrib 

sudo apt install -y linux-headers-amd64

sudo systemctl enable --now fstrim.timer