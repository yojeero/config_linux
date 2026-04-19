
# gnome remove
sudo zypper remove yelp evolution thunderbird gnome-tour 
sudo zypper remove gnome-software gnome-weather gnome-klotski 
sudo zypper remove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo zypper remove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo zypper remove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo zypper remove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo zypper remove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo zypper install thunar thunar-archive-plugin thunar-volman
sudo zypper install kitty foot fish fastfetch gnome-text-editor 
sudo zypper install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo zypper install neovim ffmpeg 7zip jq fzf imagemagick lxappearance 
sudo zypper install feh cava dunst imv scrot grim slurp celluloid rhythmbox 
sudo zypper install qt6ct qt5ct qt6-wayland blueman brightnessctl

# ubuntu look
sudo zypper install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo zypper install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo zypper install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# set fish to shell
fish

# ===================================
# bspwm 
# ===================================
sudo zypper install bspwm sxhkd rofi picom polybar

# local rpm install
sudo zypper install code_1.102.0-1752099874_amd64.deb
sudo zypper install google-chrome-stable_current_amd64.deb
curl -f https://zed.dev/install.sh | sh


