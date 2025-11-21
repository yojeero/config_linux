
# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
curl -fsSL https://install.danklinux.com | sh

# ====================================
#  bspwm 
# ====================================
yay -S bspwm sxhkd rofi picom polybar

# =====================================
# Sway
# =====================================
yay -S sway swaybg swayidle swaylock wlroots wl-clipboard waybar
yay -S wofi kanshi mako grim slurp wf-recorder light yad wlogout
yay -S mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr
yay -S playerctl pastel python-pywal rofi pulsemixer

# =====================================
# River
# =====================================
sudo pacman -S river swaybg jq findutils waybar mpd ncmpcpp swayidle dmenu
sudo pacman -S brightnessctl mako cliphist grim slurp pamixer polkit-gnome 
sudo pacman -S xdg-utils gvfs gvfs-mtp gvfs-nfs playerctl foot network-manager-applet
sudo pacman -S grimshot starship xdg-user-dirs wl-clipboard wf-recorder

yay -S tela-circle-icon-theme-manjaro tokyonight-gtk-theme-git
yay -S ttf-jetbrains-mono-nerd rofi-lbonn-wayland swaylock-effects nwg-look
yay -S rivercarro wl-clipboard-history-git mpdris2 