
# gnome remove
sudo emerge --ask --depclean yelp evolution thunderbird gnome-tour 
sudo emerge --ask --depclean gnome-software gnome-weather gnome-klotski 
sudo emerge --ask --depclean gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo emerge --ask --depclean gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo emerge --ask --depclean gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo emerge --ask --depclean gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo emerge --ask --depclean libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo emerge --ask kitty foot fastfetch gnome-text-editor lf vifm micro

# sudo zypper thunar thunar-archive-plugin thunar-volman
sudo zypper yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

sudo emerge --ask wget git gparted btop gvfs udisks2 ntfs-3g 
sudo emerge --ask feh cava dunst imv scrot grim slurp 
sudo emerge --ask celluloid rhythmbox 
sudo emerge --ask qt6ct qt5ct qt6-wayland lxappearance 
sudo zypper blueman brightnessctl

sudo emerge --ask fish
chsh -s $(command -v fish)

# local rpm install
sudo emerge --ask vscode.rpm
sudo emerge --ask google-chrome.rpm

# ubuntu look
sudo emerge --ask plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo emerge --ask ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo emerge --ask gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# ===================================
# bspwm 
# ===================================
sudo emerge --ask bspwm sxhkd rofi picom polybar



