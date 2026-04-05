
# =======================================
# Hyprland
# https://github.com/void-land/hyprland-void-packages
# =======================================
echo 'repository=https://github.com/void-land/hyprland-void-packages/releases/latest/download/' | sudo tee /etc/xbps.d/hyprland-packages.conf

sudo xbps-install -S
sudo xbps-install -Sy hyprland hyprland-devel aquamarine hyprcursor hypridle hyprland-protocols hyprlang hyprlock hyprpaper hyprutils hyprwayland-scanner xdg-desktop-portal-hyprland

# ========================================
# Niri
# ========================================
sudo xbps-install niri hyprlock hyprpicker swaybg swaylock wl-clipboard \
                waybar mako grim slurp wf-recorder light yad mpv mpd \
                mpc viewnior xfce-polkit xwayland-satellite \
                xdg-desktop-portal-gnome gnome-keyring pulsemixer \
                xorg-xwayland playerctl pastel python-pywal rofi 

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