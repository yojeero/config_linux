
# gnome remove
sudo zypper remove yelp evolution thunderbird gnome-tour 
sudo zypper remove gnome-software gnome-weather gnome-klotski 
sudo zypper remove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo zypper remove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo zypper remove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo zypper remove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo zypper remove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo zypper install kitty foot fastfetch gnome-text-editor lf vifm micro

# sudo zypper thunar thunar-archive-plugin thunar-volman
sudo zypper yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

sudo zypper install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo zypper install feh cava dunst imv scrot grim slurp 
sudo zypper install celluloid rhythmbox 
sudo zypper install qt6ct qt5ct qt6-wayland lxappearance 
sudo zypper blueman brightnessctl

sudo zypper install fish
chsh -s $(command -v fish)

# local rpm install
sudo zypper install vscode.rpm
sudo zypper install google-chrome.rpm

# ubuntu look
sudo zypper install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo zypper install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo zypper install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# ===================================
# bspwm 
# ===================================
sudo zypper install bspwm sxhkd rofi picom polybar



