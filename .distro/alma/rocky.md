
# epel repo
dnf list --available
dnf search

dnf config-manager --set-enabled crb
dnf install epel-release
crb enable

# live login

dnf -q ls --installed

sudo dnf remove yelp gnome-tour gnome-software gnome-weather gnome-characters gnome-maps gnome-contacts       
sudo dnf remove yelp libreoffice libreoffice-core libreoffice-common       

# reload fonts
sudo fc-cache -f -v

# ======================================
# install Gnome Extensions
# ======================================
sudo flatpak install com.mattjakeman.ExtensionManager
# or
sudo dnf install gnome-extensions-app
 
Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer

# packagers ===========================
sudo dnf install thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor
sudo dnf install kitty foot firefox fish fastfetch 
sudo dnf install wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g 
sudo dnf install ffmpeg 7zip jq poppler fd fzf zoxide
sudo dnf install feh cava dunst imv scrot grim slurp celluloid rhythmbox
sudo dnf install qt6ct qt5ct blueman brightnessctl NetworkManager 
sudo dnf install lxappearance gtk-murrine-engine lxappearance

# betterlockscreen 
sudo dnf copr enable balamurali27/betterlockscreen

# exec grim -g "$(slurp)" $(date +'%F_%T.png')

# set fish to shell
fish

# =======================================
# bspwm
# =======================================
sudo dnf install bspwm sxhkd rofi picom polybar 

# =======================================
# GDM to lightdm
# =======================================
sudo dnf install lightdm
sudo systemctl disable gdm.service
sudo systemctl enable lightdm.service
reboot
