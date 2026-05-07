
# gnome remove
sudo dnf remove yelp evolution thunderbird gnome-tour 
sudo dnf remove gnome-software gnome-weather gnome-klotski 
sudo dnf remove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo dnf remove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo dnf remove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo dnf remove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo dnf remove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo dnf install kitty foot fastfetch gnome-text-editor lf vifm micro

# sudo dnf thunar thunar-archive-plugin thunar-volman
sudo dnf yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

sudo dnf install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo dnf install feh cava dunst imv scrot grim slurp 
sudo dnf install celluloid rhythmbox 
sudo dnf install qt6ct qt5ct qt6-wayland lxappearance 
sudo dnf blueman brightnessctl

sudo dnf install fish
chsh -s $(command -v fish)

# local rpm install
sudo dnf install vscode.rpm
sudo dnf install google-chrome.rpm

# ubuntu look
sudo dnf install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo dnf install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo dnf install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# ===================================
# bspwm 
# ===================================
sudo dnf install bspwm sxhkd rofi picom polybar



