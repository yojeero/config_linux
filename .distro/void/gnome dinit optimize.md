# =========================
# GNOME on Void Linux + dinit
# Minimal and optimized installation
# =========================

# System update
sudo xbps-install -Su

# -------------------------------------------------
# Install Dinit
# -------------------------------------------------

sudo xbps-install -S dinit dinit-services

# If you are migrating from runit:
sudo xbps-remove -R runit-void

# -------------------------------------------------
# Basic GNOME without garbage
# -------------------------------------------------

sudo xbps-install -S\
gnome-shell\
gnome-session\
gnome-control-center\
gnome-settings-daemon\
mutter\
gvfs\
nautilus\
gdm\
file-roller\
gnome-shell-extensions\
gnome-screenshot\
gnome-tweaks\
dbus\
polkit

# -------------------------------------------------
# Enabling Dinit services
# -------------------------------------------------

sudo ln -s /etc/dinit.d/dbus /etc/dinit.d/boot.d/
sudo ln -s /etc/dinit.d/polkitd /etc/dinit.d/boot.d/
sudo ln -s /etc/dinit.d/gdm /etc/dinit.d/boot.d/

#NetworkManager
sudo xbps-install -S NetworkManager
sudo ln -s /etc/dinit.d/NetworkManager /etc/dinit.d/boot.d/

# Checking services
dinitctl list

# Start manually
sudo dinitctl start gdm
sudo dinitctl start NetworkManager

# -------------------------------------------------
# Removing unnecessary GNOME software
# -------------------------------------------------
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
malcontent

# -------------------------------------------------
# Disable unnecessary GNOME services
# -------------------------------------------------

mkdir -p ~/.config/autostart
for svc in\
org.gnome.SettingsDaemon.Wacom.desktop\
org.gnome.SettingsDaemon.PrintNotifications.desktop\
org.gnome.SettingsDaemon.Color.desktop\
org.gnome.SettingsDaemon.A11ySettings.desktop\
org.gnome.SettingsDaemon.UsbProtection.desktop\
org.gnome.SettingsDaemon.Sharing.desktop\
org.gnome.SettingsDaemon.Smartcard.desktop\
org.gnome.SettingsDaemon.Housekeeping.desktop\
org.gnome.SettingsDaemon.Power.desktop
do
cp /etc/xdg/autostart/$svc ~/.config/autostart/2>/dev/null
echo "Hidden=true" >> ~/.config/autostart/$svc
done

# -------------------------------------------------
# Tracker and indexers
# -------------------------------------------------

# Completely remove the indexer:
sudo xbps-remove -R tracker tracker-miners

# -------------------------------------------------
# GNOME Optimization
# -------------------------------------------------

# Disable animations
gsettings set org.gnome.desktop.interface enable-animations false
# Reduce timeout Mutter
gsettings set org.gnome.mutter check-alive-timeout 0

# Disable hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Disable auto-lock
gsettings set org.gnome.desktop.session idle-delay 0

# Disable suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# -------------------------------------------------
# PipeWire (recommended)
# -------------------------------------------------

sudo xbps-install -S\
pipewire\
wireplumber\
alsa-pipewire

# Dinit PipeWire services
sudo ln -s /etc/dinit.d/pipewire /etc/dinit.d/user/
sudo ln -s /etc/dinit.d/wireplumber /etc/dinit.d/user/

# -------------------------------------------------
#Wayland/X11
# -------------------------------------------------

# Wayland recommended
# For NVIDIA:
sudo xbps-install -S nvidia

# For X11:
sudo xbps-install -S xorg
# -------------------------------------------------
# Compiling packages for hardware
# -------------------------------------------------

mkdir -p ~/.config

cat > ~/.config/xbps-src.conf << EOF
XBPS_MAKEJOBS=$(nproc)
XBPS_CFLAGS="-march=native -mtune=native -O2 -pipe"
XBPS_CXXFLAGS="\$XBPS_CFLAGS"
XBPS_RUSTFLAGS="-C opt-level=3"
EOF

# Build tools
sudo xbps-install -S\
base-devel\
git\
curl\
ccache

# -------------------------------------------------
# Building GNOME components via xbps-src
# -------------------------------------------------

git clone https://github.com/void-linux/void-packages.git
cd void-packages

./xbps-src binary-bootstrap

# Rebuilding mutter
./xbps-src pkg mutter

# Rebuilding gnome-shell
./xbps-src pkg gnome-shell

# Installing built packages
sudo xbps-install --repository hostdir/binpkgs gnome-shell mutter

# -------------------------------------------------
# Additional lightweight replacements
# -------------------------------------------------

# Instead of Nautilus:
sudo xbps-install -S thunar

# Instead of File Roller:
sudo xbps-install -S xarchiver

# Lightweight image viewer:
sudo xbps-install -S nsxiv

# -------------------------------------------------
# Useful checks
# -------------------------------------------------

# Wayland check
echo $XDG_SESSION_TYPE

# GNOME Shell check
gnome-shell --version

# Dinit check
dinitctl --version
# -------------------------------------------------
# Bottom line
# -------------------------------------------------

# After GNOME + Dinit optimization:
# -RAM after login ~800-1100 MB
# -fewer background processes
# -faster launch of GNOME Shell
# -less CPU wakeups
# -smooth Wayland
# -fast cold boot
# -modern GTK4 stack

# Dinit usually:
# -faster than systemd/runit at startup
# -simpler in architecture
# -less overhead
# -easier to debug