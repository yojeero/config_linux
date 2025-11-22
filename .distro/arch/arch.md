
# update 
sudo pacman -Syuu

# install yay -----------------
sudo pacman -S yay

# refresh the system packages and upgrade
yay -Syu

# packagers --------------------
yay -Sy thunar thunar-archive-plugin thunar-volman
yay -Sy kitty foot fish fastfetch gnome-text-editor 

# set fish to shell
chsh -s `which fish` 

yay -Sy wget git gparted btop gvfs udisks2 ntfs-3g 
yay -Sy neovim yazi ffmpeg 7zip jq poppler fd fzf imagemagick
yay -Sy feh cava dunst imv scrot grim slurp celluloid rhythmbox 
yay -Sy qt6ct qt5ct qt5-wayland qt6-wayland blueman 
yay -Sy brightnessctl networkmanager eww
        
yay -Sy lxappearance gtk-murrine-engine gtk2-engine-murrine

yay -Sy --noconfirm google-chrome visual-studio-code-bin zed-git

# install Gnome extensions

# extensions 
Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer
