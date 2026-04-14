
# update 
sudo pacman -Syuu

# packagers --------------------
sudo pacman -S thunar thunar-archive-plugin thunar-volman kitty foot fish fastfetch gnome-text-editor 

# set fish to shell
chsh -s `which fish` 

sudo pacman -Sy wget git gparted btop gvfs udisks2 ntfs-3g 
sudo pacman -Sy neovim yazi ffmpeg 7zip jq poppler fd fzf imagemagick
sudo pacman -Sy feh cava dunst imv scrot grim slurp celluloid rhythmbox 
sudo pacman -Sy qt6ct qt5ct qt5-wayland qt6-wayland blueman 
sudo pacman -Sy brightnessctl networkmanager eww
        
sudo pacman -Sy lxappearance gtk-murrine-engine gtk2-engine-murrine

sudo pacman -Sy --noconfirm google-chrome visual-studio-code-bin zed-git

# install Gnome extensions

# extensions 
Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer
Blur my Shell
