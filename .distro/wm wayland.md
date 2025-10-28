# =======================================
# Hyprland
# =======================================
hyprland swaybg swayidle swaylock wlroots wl-clipboard \
waybar wofi mako grim slurp wf-recorder light yad mpv \
mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
playerctl pastel python-pywal rofi pulsemixer

# ========================================
# Niri
# ========================================
niri hyprlock hyprpicker swaybg swaylock wl-clipboard \
waybar mako grim slurp wf-recorder light yad mpv mpd \
mpc viewnior xfce-polkit xwayland-satellite xdg-desktop-portal \
xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring \
xorg-xwayland playerctl pastel python-pywal rofi pulsemixer

# =====================================
# Sway
# ======================================
sway swaybg swayidle swaylock wlroots wl-clipboard waybar \
wofi kanshi mako grim slurp wf-recorder light yad wlogout \
mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
playerctl pastel python-pywal rofi pulsemixer

# ==========================================
# River
# ==========================================
river lua lua-posix wlr-randr swaybg swayidle swaylock wlroots \
wl-clipboard waybar wofi mako grim slurp wf-recorder light yad \
mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
playerctl pastel python-pywal rofi pulsemixer

# ==========================================
# betterlockscreen
# ==========================================
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

# ===============================================
# install Gnome Extensions
# ===============================================
sudo apt-get install
sudo dnf install
sudo apk add
sudo pacman -S
sudo xbps-install
sudo eopkg install
                  gnome-shell-extension-manager \
                  blueprint-compiler gettext libadwaita-1-dev \
                  libgtk-4-dev libjson-glib-dev libsoup-3.0-dev \
                  libxml2-dev meson

# search and install extensions
Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer
