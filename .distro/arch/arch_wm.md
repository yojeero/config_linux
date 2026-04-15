
# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
curl -fsSL https://install.danklinux.com | sh

# ====================================
#  bspwm 
# ====================================
sudo pacman -S bspwm sxhkd rofi picom polybar

# =====================================
# Sway
# =====================================
sudo pacman -S sway swaybg swayidle swaylock wlroots wl-clipboard kanshi grim slurp wf-recorder light yad wlogout mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr playerctl pastel python-pywal pulsemixer hyprpicker hyprlock imagemagick waybar foot fuzzel

# =====================================
# River
# =====================================
sudo pacman -S river swaybg jq findutils mpd ncmpcpp swayidle brightnessctl cliphist grim slurp pamixer polkit-gnome xdg-utils gvfs gvfs-mtp gvfs-nfs playerctl network-manager-applet grimshot starship xdg-user-dirs wl-clipboard wf-recorder wlr-randr swaylock hyprpicker hyprlock light yad mpv mpd mpc viewnior imagemagick xfce-polkit xorg-xwayland xdg-desktop-portal-wlr playerctl pastel python-pywal pulsemixer waybar foot fuzzel

sudo pacman -S tela-circle-icon-theme-manjaro tokyonight-gtk-theme-git ttf-jetbrains-mono-nerd rofi-lbonn-wayland swaylock-effects nwg-look rivercarro wl-clipboard-history-git mpdris2 

# =====================================
# niri
# =====================================
sudo pacman -S niri hyprlock hypridle hyprpicker swaybg swaylock wl-clipboard grim slurp wf-recorder light yad mpv mpd mpc viewnior imagemagick xfce-polkit xwayland-satellite xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring xorg-xwayland playerctl pastel python-pywal alacritty pulsemixer waybar foot fuzzel

# =====================================
# mangowc
# =====================================
sudo pacman -S mangowc-git hyprlock hypridle hyprpicker swaybg swaylock wl-clipboard grim slurp wf-recorder light yad mpv mpd mpc viewnior imagemagick xfce-polkit xwayland-satellite xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring xorg-xwayland playerctl pastel python-pywal pulsemixer waybar foot fuzzel  

# =====================================
# betterlockscreen
# =====================================
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
