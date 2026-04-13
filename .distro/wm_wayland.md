
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
# =====================================
sway swaybg swayidle swaylock wlroots wl-clipboard waybar \
wofi kanshi mako grim slurp wf-recorder light yad wlogout \
mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
playerctl pastel python-pywal rofi pulsemixer

# =====================================
# River
# =====================================
river lua lua-posix wlr-randr swaybg swayidle swaylock wlroots \
wl-clipboard waybar wofi mako grim slurp wf-recorder light yad \
mpv mpd mpc viewnior xfce-polkit xorg-xwayland xdg-desktop-portal-wlr \
playerctl pastel python-pywal rofi pulsemixer

# =====================================
# betterlockscreen
# =====================================
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

# =====================================
# arch dwl
# =====================================
sudo pacman -S wayland wayland-protocols wlroots_0_19 foot base-devel git wmenu wl-clipboard grim slurp swaybg firefox ttf-jetbrains-mono-nerd

# =====================================
# gentoo dwl
# =====================================
sudo emerge -av dev-libs/wayland dev-libs/wayland-protocols gui-libs/wlroots x11-terms/foot sys-devel/base-devel dev-vcs/git gui-apps/wmenu gui-apps/wl-clipboard media-gfx/grim gui-apps/slurp gui-apps/swaybg www-client/firefox media-fonts/jetbrains-mono

