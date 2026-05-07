
# MBR

/dev/sda1 ext4 /  Flags → boot

# grub in 
/dev/sda

# gnome remove
sudo eopkg remove yelp evolution thunderbird gnome-tour 
sudo eopkg remove gnome-software gnome-weather gnome-klotski 
sudo eopkg remove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo eopkg remove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo eopkg remove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo eopkg remove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo eopkg remove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo eopkg install kitty foot fastfetch gnome-text-editor lf vifm micro

# sudo eopkg thunar thunar-archive-plugin thunar-volman
sudo eopkg yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

sudo eopkg install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo eopkg install feh cava dunst imv scrot grim slurp 
sudo eopkg install celluloid rhythmbox 
sudo eopkg install qt6ct qt5ct qt6-wayland lxappearance 
sudo eopkg blueman brightnessctl

sudo eopkg install fish
chsh -s $(command -v fish)

# ubuntu look
sudo eopkg install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo eopkg install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo eopkg install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# ===================================
# bspwm 
# ===================================
sudo eopkg install bspwm sxhkd rofi picom polybar



