# GNOME ultra-minimal + greeted + tuigreet

# ==========================================================
# GNOME Ultra-Minimal
# Void Linux + greeted + tuigreet
# Without GDM
# ==========================================================

# Goal:
# -minimum overhead
# -fast boot/login
# -less RAM
# -Wayland GNOME
# -without heavy GDM

# ==========================================================
# Install GNOME
# ==========================================================

sudo xbps-install -S\
gnome-shell\
gnome-session\
gnome-control-center\
gnome-settings-daemon\
mutter\
gvfs\
nautilus\
dbus\
polkit\
pipewire\
wireplumber\
xdg-desktop-portal\
xdg-desktop-portal-gnome

#Additional
sudo xbps-install -S\
gnome-tweaks\
file-roller\
gnome-screenshot

# ==========================================================
# Install greetd + tuigreet
# ==========================================================

sudo xbps-install -S greeted tuigreet

# ==========================================================
# Enabling services (runit)
# ==========================================================

sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/polkitd /var/service
sudo ln -s /etc/sv/greetd /var/service
sudo ln -s /etc/sv/NetworkManager /var/service

#Audio
sudo ln -s /etc/sv/pipewire /var/service
sudo ln -s /etc/sv/wireplumber /var/service

# ==========================================================
# Config greetd
# ==========================================================

sudo nano /etc/greetd/config.toml
# ==========================================================
# TOML
# ==========================================================
[terminal]
vt = 1

[default_session]

command = "tuigreet --time --remember --cmd 'dbus-run-session gnome-session'"
user = "_greetd"

# ==========================================================
# Important for Wayland GNOME
# ==========================================================

mkdir -p ~/.config/environment.d

nano ~/.config/environment.d/gnome.conf


# ==========================================================
#INI
# ==========================================================
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=GNOME
XDG_SESSION_DESKTOP=gnome
GDK_BACKEND=wayland
QT_QPA_PLATFORM=wayland
SDL_VIDEODRIVER=wayland
MOZ_ENABLE_WAYLAND=1

# ==========================================================
# Removing GNOME junk
# ==========================================================

sudo xbps-remove -R\
epiphany\
gnome-boxes\
gnome-calculator\
gnome-calendar\
gnome-contacts\
gnome-maps\
gnome-music\
gnome-weather\
gnome-clocks\
gnome-photos\
gnome-software\
totem\
yelp\
simple-scan\
eog\
orca\
vino\
rygel\
gnome-logs\
gnome-remote-desktop\
tracker\
tracker-miners

# ==========================================================
# Disable unnecessary autoruns
# ==========================================================

mkdir -p ~/.config/autostart

for svc in\
org.gnome.SettingsDaemon.Wacom.desktop\
org.gnome.SettingsDaemon.PrintNotifications.desktop\
org.gnome.SettingsDaemon.Color.desktop\
org.gnome.SettingsDaemon.A11ySettings.desktop\
org.gnome.SettingsDaemon.UsbProtection.desktop\
org.gnome.SettingsDaemon.Sharing.desktop\
org.gnome.SettingsDaemon.Smartcard.desktop\
org.gnome.SettingsDaemon.Housekeeping.desktop
do
cp /etc/xdg/autostart/$svc ~/.config/autostart/2>/dev/null
echo "Hidden=true" >> ~/.config/autostart/$svc
done

# ==========================================================
# GNOME Tweaks
# ==========================================================

# disable animations
gsettings set org.gnome.desktop.interface enable-animations false

# disable hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

# disable idle suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# disable lock screen timeout
gsettings set org.gnome.desktop.session idle-delay 0

# ==========================================================
# NVIDIA (if needed)
# ==========================================================
sudo xbps-install -S nvidia

# ==========================================================
# Check
# ==========================================================

echo $XDG_SESSION_TYPE
echo $XDG_CURRENT_DESKTOP

# should be:
#wayland
# GNOME

# ==========================================================
#RAM usage
# ==========================================================

# Typically:
# GNOME + GDM:
# ~1.1–1.5 GB idle

# GNOME + greeting:
# ~750–1100 MB idle

# ==========================================================
# Why is it faster than GDM
# ==========================================================

# No:
# -second gnome-shell for login screen
# -gdm daemon overhead
# -extra DBus activation
# -greeter compositor

# ==========================================================
# Even easier?
# ==========================================================

# instead of nautilus:
sudo xbps-install -S thunar

# instead of file-roller:
sudo xbps-install -S xarchiver

# ==========================================================
# The most minimal option
# ==========================================================

# without display manager at all:

tty
→login
→ dbus-run-session gnome-session

# This is the minimum possible overhead.