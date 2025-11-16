
# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
curl -fsSL https://install.danklinux.com | sh

# ====================================
#  bspwm 
# ====================================
yay -S bspwm sxhkd rofi picom polybar

# ====================================
# hyprland    
# ====================================

# Core Hyprland & Session
yay -S hyprland hyprpaper swaylock-effects swayidle

# Panels and notifications
yay -S waybar swaync libnotify

# xdg/Portal/Policy
yay -S xdg-desktop-portal-hyprland polkit-gnome

# Clipboard and tools
yay -S wl-clipboard cliphist

# Screenshots
yay -S grim slurp swappy

# Audio/Media
yay -S wireplumber pavucontrol playerctl

# Display and utilities
yay -S hyprsunset brightnessctl wlr-randr wtype

# Network and bluetooth
yay -S network-manager-applet blueman wireless_tools

# Desktop and UI layers
yay -S gtk4-layer-shell qt5-wayland qt6-wayland qt5ct

# Application Launcher
yay -S walker-bin libqalculate 

# Fonts
yay -S ttf-nerd-fonts-symbols-mono
