
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
sudo dnf install thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor \ 
                kitty foot firefox fish fastfetch \ 
                wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g \ 
                ffmpeg 7zip jq poppler fd fzf zoxide \ 
                feh cava dunst imv scrot grim slurp celluloid rhythmbox \ 
                qt6ct qt5ct blueman brightnessctl NetworkManager \ 
                lxappearance gtk-murrine-engine lxappearance

# betterlockscreen 
sudo dnf copr enable balamurali27/betterlockscreen

# exec grim -g "$(slurp)" $(date +'%F_%T.png')

# set fish to shell
fish

# =======================================
# bspwm
# =======================================
sudo dnf install bspwm sxhkd rofi picom polybar 

# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
sudo dnf copr enable avengemedia/dms
sudo dnf install dms

# =======================================
# GDM to lightdm
# =======================================
sudo dnf install lightdm
sudo systemctl disable gdm.service
sudo systemctl enable lightdm.service
reboot
