 # sudoers error 
su -
nano /etc/sudoers
yopy ALL=(ALL:ALL) ALL
ctrl + x
Yes

# add user to sudo 
usermod –a –G sudo yopy

# reload fonts
sudo fc-cache -f -v

# local deb install
sudo dpkg -i code_1.102.0-1752099874_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
curl -f https://zed.dev/install.sh | sh

# gnome remove
sudo apt autoremove yelp evolution thunderbird gnome-tour \ 
                    gnome-software gnome-weather gnome-klotski \ 
                    gnome-mahjongg gnome-chess gnome-games gnome-mines \ 
                    gnome-nibbles gnome-robots gnome-sudoku gnome-sushi \ 
                    gnome-taquin gnome-tetravex gnome-characters gnome-maps \ 
                    gnome-contacts gnome-2048 swell-foop aisleriot shotwell \ 
                    libreoffice libreoffice-common xfburn xfce4-dict

# install packagers 
sudo apt install thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor \ 
                kitty foot firefox fish fastfetch \ 
                wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g \ 
                neovim ffmpeg 7zip jq fzf zoxide imagemagick lxappearance \ 
                feh cava dunst imv scrot grim slurp celluloid rhythmbox \ 
                qt6ct qt5ct qt6-wayland blueman brightnessctl

sudo apt install yazi poppler fd eww qt5-wayland networkmanager \ 
                gtk-murrine-engine gtk2-engine-murrine quodlibet exfalso

# set fish to shell
fish

# ===================================
# bspwm 
# ===================================
sudo apt install bspwm sxhkd rofi picom polybar
