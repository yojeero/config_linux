# live login

dnf -q ls --installed

sudo dnf remove yelp gnome-tour gnome-software gnome-weather \ 
                gnome-characters gnome-maps libreoffice libreoffice-* \ 
                libreoffice-common

# reload fonts
sudo fc-cache -f -v

# ======================================
# install Gnome Extensions
# ======================================
sudo dnf install gnome-shell-extension-manager

sudo dnf install blueprint-compiler gettext libadwaita-1-dev \ 
                libgtk-4-dev libjson-glib-dev libsoup-3.0-dev \ 
                libxml2-dev meson
 
Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer

# packagers ===========================
sudo dnf install thunar thunar-archive-plugin thunar-volman mousepad \ 
                kitty foot firefox fish fastfetch \ 
                wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g gnome-tweaks \ 
                ffmpeg 7zip jq poppler fd ripgrep fzf zoxide \ 
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

# =======================================
# hyprland
# =======================================
sudo dnf copr enable solopasha/hyprland

# =======================================
# GDM to lightdm
# =======================================
sudo dnf install lightdm
sudo systemctl disable gdm.service
sudo systemctl enable lightdm.service
reboot

