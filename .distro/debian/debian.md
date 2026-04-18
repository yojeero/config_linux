
# gnome remove
sudo apt autoremove yelp evolution thunderbird gnome-tour 
sudo apt autoremove gnome-software gnome-weather gnome-klotski 
sudo apt autoremove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo apt autoremove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo apt autoremove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo apt autoremove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo apt autoremove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo apt install thunar thunar-archive-plugin thunar-volman
sudo apt install kitty foot fish fastfetch gnome-text-editor 
sudo apt install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo apt install neovim ffmpeg 7zip jq fzf imagemagick lxappearance 
sudo apt install feh cava dunst imv scrot grim slurp celluloid rhythmbox 
sudo apt install qt6ct qt5ct qt6-wayland blueman brightnessctl

# ubuntu look
sudo apt install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo apt install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo apt install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# set fish to shell
fish

# ===================================
# bspwm 
# ===================================
sudo apt install bspwm sxhkd rofi picom polybar

# local deb install
sudo dpkg -i code_1.102.0-1752099874_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
curl -f https://zed.dev/install.sh | sh

# sudoers error 
su -
nano /etc/sudoers
yopy ALL=(ALL:ALL) ALL
ctrl + x
Yes

