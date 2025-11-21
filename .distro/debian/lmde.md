
# reload fonts
sudo fc-cache -f -v

# local deb install
sudo dpkg -i code_1.102.0-1752099874_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
curl -f https://zed.dev/install.sh | sh

# gnome remove
sudo apt autoremove yelp thunderbird libreoffice-common 

# install packagers 
sudo apt install thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor
sudo apt install firefox kitty foot fish fastfetch
sudo apt install wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g
sudo apt install neovim ffmpeg 7zip jq fzf imagemagick lxappearance
sudo apt install feh cava dunst imv scrot grim slurp celluloid rhythmbox
sudo apt install qt6ct qt5ct qt6-wayland blueman brightnessctl

sudo apt install yazi poppler fd eww qt5-wayland networkmanager
sudo apt install gtk-murrine-engine gtk2-engine-murrine quodlibet exfalso

# set fish to shell
fish

# =================================
# bspwm 
# ==================================
sudo apt install bspwm sxhkd rofi picom polybar