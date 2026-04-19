
sudo dnf install dnf5

# gnome remove
sudo dnf5 autoremove yelp evolution thunderbird gnome-tour 
sudo dnf5 autoremove gnome-software gnome-weather gnome-klotski 
sudo dnf5 autoremove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo dnf5 autoremove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo dnf5 autoremove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo dnf5 autoremove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo dnf5 autoremove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo dnf5 install thunar thunar-archive-plugin thunar-volman
sudo dnf5 install kitty foot fish fastfetch gnome-text-editor 
sudo dnf5 install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo dnf5 install neovim ffmpeg 7zip jq fzf imagemagick lxappearance 
sudo dnf5 install feh cava dunst imv scrot grim slurp celluloid rhythmbox 
sudo dnf5 install qt6ct qt5ct qt6-wayland blueman brightnessctl

# ubuntu look
sudo dnf5 install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo dnf5 install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo dnf5 install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# set fish to shell
fish

# ===================================
# bspwm 
# ===================================
sudo dnf5 install bspwm sxhkd rofi picom polybar

# local rpm install
sudo yum localinstall code_1.102.0-1752099874_amd64.deb
sudo yum localinstall google-chrome-stable_current_amd64.deb
curl -f https://zed.dev/install.sh | sh


