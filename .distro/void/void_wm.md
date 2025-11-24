
# =======================================
# Hyprland
# =======================================
sudo xbps-install hyprland swaybg swayidle swaylock wlroots wl-clipboard \   
                waybar wofi mako grim slurp wf-recorder light yad mpv \
               viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
                playerctl pastel python-pywal rofi pulsemixer mpd mpc 

# ========================================
# Niri
# ========================================
sudo xbps-install niri hyprlock hyprpicker swaybg swaylock wl-clipboard \
                waybar mako grim slurp wf-recorder light yad mpv mpd \
                mpc viewnior xfce-polkit xwayland-satellite \
                xdg-desktop-portal-gnome gnome-keyring pulsemixer \
                xorg-xwayland playerctl pastel python-pywal rofi 

# =====================================
# Sway
# =====================================
sudo xbps-install sway swaybg swayidle swaylock wlroots wl-clipboard waybar \
                wofi kanshi mako grim slurp wf-recorder light yad wlogout \
                mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
                playerctl pastel python-pywal rofi pulsemixer

# =====================================
# River
# =====================================
sudo xbps-install river lua lua-posix wlr-randr swaybg swayidle swaylock wlroots \
                wl-clipboard waybar wofi mako grim slurp wf-recorder light yad \
                mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
                playerctl pastel python-pywal rofi pulsemixer

# =====================================
# betterlockscreen
# =====================================
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system