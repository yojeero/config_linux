
# Installing the EPEL repository
sudo yum -y update
sudo yum -y install epel-release
sudo yum repolist

# packagers
sudo dnf install thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor 
sudo dnf install kitty firefox fish fastfecth 
sudo dnf install neovim ffmpeg jq poppler fd fzf imagemagick 
sudo dnf install xrandr setxkbmap feh dbus btop celluloid rhythmbox 
sudo dnf install font-inter font-liberation font-terminus-nerd font-jetbrains-mono-nerd 
sudo dnf install lxappearance p7zip 7zip unzip tar gzip xarchiver
sudo dnf install gvfs udisks2 ntfs-3g wget git

sudo dnf install yazi gtk-murrine-engine xfce4-power-manager 

# set fish to shell
fish

# set Picom to autostart
mkdir -p ~/.config/picom

# add this line to your i3 config (.config/i3/config) to autostart Picom
exec --no-startup-id picom --config ~/.config/picom/picom.conf

# install in rpm
sudo flatpak install com.mattjakeman.ExtensionManager
# or
sudo dnf install gnome-extensions-app

# extensions 
Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer