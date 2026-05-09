
# gnome remove
sudo apt autoremove yelp evolution thunderbird gnome-tour 
sudo apt autoremove gnome-software gnome-weather gnome-klotski 
sudo apt autoremove gnome-mahjong gnome-chess gnome-games gnome-mines 
sudo apt autoremove gnome-nibbles gnome-robots gnome-sudoku gnome-sushi 
sudo apt autoremove gnome-taquin gnome-tetravex gnome-characters gnome-maps 
sudo apt autoremove gnome-contacts gnome-2048 swell-foop aisleriot shotwell 
sudo apt autoremove libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo apt install kitty firefox lf vifm micro

# sudo apt install thunar thunar-archive-plugin thunar-volman
sudo apt install nemo nemo-fileroller xed fastfetch foot
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

sudo apt install wget git gparted btop gvfs udisks2 ntfs-3g 
sudo apt install feh cava dunst imv scrot grim slurp
sudo apt install celluloid rhythmbox 
sudo apt install qt6ct qt5ct qt6-wayland lxappearance 
sudo apt install blueman brightnessctl

# set fish to shell
sudo apt update
sudo apt install fish
chsh -s $(command -v fish)

# ubuntu look
sudo apt install plymouth ecryptfs-utils curl wget python-is-python3 binutils 

sudo apt install ttf-mscorefonts-installer fonts-ubuntu fonts-ubuntu-console fonts-liberation2
fonts-noto-core fonts-noto-color-emoji fonts-dejavu fonts-hack

sudo apt install gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock gnome-shell-extension-appindicator gnome-shell-extension-system-monitor yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound yaru-theme-unity gnome-package-updater gnome-packagekit

# ===================================
# bspwm 
# ===================================
sudo apt install bspwm sxhkd rofi picom polybar

# local deb install
sudo dpkg -i vscode.deb
sudo dpkg -i google-chrome.deb
sudo dpkg -i yazi.deb

# sudoers error 
su -
nano /etc/sudoers
yopy ALL=(ALL:ALL) ALL
ctrl + x
Yes

# adding a non-free repository
sudo apt-add-repository non-free contrib 

# For proprietary x64 drivers
sudo apt install linux-headers-amd64

# x32 без PAE
sudo apt install linux-headers-686

# x32 PAE
sudo apt install linux-headers-686-pae

# Adding the latest kernel for the latest drivers
sudo apt install -t bookworm-backports

# install Debian Bookworm drivers
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
sudo apt update
sudo apt install nvidia-driver firmware-misc-nonfree

# list installed packagers
dpkg --list 

# Useful for SSD

# After installation, check TRIM
systemctl status fstrim.timer

# If inactive
sudo systemctl enable --now fstrim.timer

