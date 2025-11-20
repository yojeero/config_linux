
# update 
sudo pacman -Syuu

# install yay -----------------
sudo pacman -S yay

# refresh the system packages and upgrade
yay -Syu

# packagers --------------------
yay -Sy thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor 
yay -Sy kitty foot firefox fish fastfetch

# set fish to shell
chsh -s `which fish` 

yay -Sy wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g 
yay -Sy neovim yazi ffmpeg 7zip jq poppler fd fzf zoxide imagemagick
yay -Sy feh cava dunst eww imv scrot grim slurp celluloid rhythmbox 
yay -Sy qt6ct qt5ct qt5-wayland qt6-wayland blueman brightnessctl networkmanager 
        
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

# wps office arch
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si

sudo systemctl enable --now snapd.socket

sudo ln -s /var/lib/snapd/snap /snap
