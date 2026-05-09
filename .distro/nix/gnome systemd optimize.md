# =========================
# GNOME on Linux + systemd
# Minimal and optimized installation
# =========================

# Suitable for:
# -Arch Linux
# -Fedora
# -Debian
# -Ubuntu
# -openSUSE
# -any systemd distributions

# -------------------------------------------------
# Install GNOME
# -------------------------------------------------

#Arch:
sudo pacman -S\
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
gnome-tweaks

# Debian/Ubuntu:
sudo apt install\
gnome-shell\
gnome-session\
gnome-control-center\
gnome-settings-daemon\
mutter\
gvfs\
nautilus\
gdm3\
file-roller\
gnome-shell-extensions\
gnome-screenshot\
gnome-tweaks

# Fedora:
sudo dnf install\
gnome-shell\
gnome-session\
gnome-control-center\
gnome-settings-daemon\
mutter\
gvfs\
nautilus\
gdm\
file-roller\
gnome-extensions-app\
gnome-screenshot\
gnome-tweaks

# -------------------------------------------------
# Enabling services
# -------------------------------------------------

sudo systemctl enable --now gdm
sudo systemctl enable --now NetworkManager

# Check
systemctl status gdm
systemctl status NetworkManager

# -------------------------------------------------
# Removing unnecessary GNOME software
# -------------------------------------------------
#Arch:
sudo pacman -Rsn\
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

# Debian/Ubuntu:
sudo apt purge\
epiphany-browser\
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
orca

# Fedora:
sudo dnf remove\
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
orca

# -------------------------------------------------
# Disable unnecessary GNOME user services
# -------------------------------------------------

# Wacom graphics tablet
systemctl --user mask org.gnome.SettingsDaemon.Wacom.service

# Print notifications
systemctl --user mask org.gnome.SettingsDaemon.PrintNotifications.service

# Color profiles
systemctl --user mask org.gnome.SettingsDaemon.Color.service

#Accessibility
systemctl --user mask org.gnome.SettingsDaemon.A11ySettings.service

# USB Protection
systemctl --user mask org.gnome.SettingsDaemon.UsbProtection.service

# Sharing
systemctl --user mask org.gnome.SettingsDaemon.Sharing.service

#Smartcard
systemctl --user mask org.gnome.SettingsDaemon.Smartcard.service

#Housekeeping
systemctl --user mask org.gnome.SettingsDaemon.Housekeeping.service

# Power plugin
systemctl --user mask org.gnome.SettingsDaemon.Power.service

# Evolution background services
systemctl --user mask\
evolution-addressbook-factory.service\
evolution-calendar-factory.service\
evolution-source-registry.service

# -------------------------------------------------
# Tracker /indexer
# -------------------------------------------------

# Disable tracker
systemctl --user mask tracker-miner-fs-3.service
systemctl --user mask tracker-extract-3.service
systemctl --user mask tracker-writeback-3.service

# Or delete completely

#Arch:
sudo pacman -Rsn tracker3-miners

# Debian/Ubuntu:
sudo apt purge tracker tracker-miner-fs

# Fedora:
sudo dnf remove tracker-miners

# -------------------------------------------------
# GNOME Optimization
# -------------------------------------------------

# Disable animations
gsettings set org.gnome.desktop.interface enable-animations false

# Speed up mutter watchdog
gsettings set org.gnome.mutter check-alive-timeout 0

# Disable hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false
# Disable auto-lock
gsettings set org.gnome.desktop.session idle-delay 0

# Disable suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# Speed up opening windows
gsettings set org.gnome.mutter edge-tiling true

# -------------------------------------------------
#Wayland/X11
# -------------------------------------------------

# Wayland recommended

# Check:
echo $XDG_SESSION_TYPE

# NVIDIA:
#Arch
sudo pacman -S nvidia

# Debian/Ubuntu
sudo apt install nvidia-driver

#Fedora
sudo dnf install akmod-nvidia

# For X11:
#Arch
sudo pacman -S xorg

# Debian/Ubuntu
sudo apt install xorg

#Fedora
sudo dnf install @x11

# -------------------------------------------------
#PipeWire
# -------------------------------------------------

#Arch
sudo pacman -S pipewire wireplumber pipewire-pulse

# Debian/Ubuntu
sudo apt install pipewire wireplumber

#Fedora
sudo dnf install pipewire wireplumber

# Enabling user services
systemctl --user enable --now pipewire.service
systemctl --user enable --now wireplumber.service

# -------------------------------------------------
# Compilation for hardware (Arch)
# -------------------------------------------------

sudo nano /etc/makepkg.conf

CFLAGS="-march=native -mtune=native -O2 -pipe -fno-plt"
CXXFLAGS="$CFLAGS"
RUSTFLAGS="-C opt-level=3"
MAKEFLAGS="-j$(nproc)"
OPTIONS=(strip !debug lto)
# Build tools
sudo pacman -S base-devel git ccache

# -------------------------------------------------
# gnome-shell-performance (Arch AUR)
# -------------------------------------------------

git clone https://aur.archlinux.org/gnome-shell-performance.git
cd gnome-shell-performance
makepkg-sric

# -------------------------------------------------
# mutter-performance (Arch AUR)
# -------------------------------------------------
git clone https://aur.archlinux.org/mutter-performance.git
cd mutter-performance
makepkg-sric

# -------------------------------------------------
# Easy alternatives
# -------------------------------------------------

# Instead of Nautilus:
#Arch
sudo pacman -S thunar

# Debian/Ubuntu
sudo apt install thunar

#Fedora
sudo dnf install thunar

# Instead of File Roller:
#Arch
sudo pacman -S xarchiver

# Debian/Ubuntu
sudo apt install xarchiver

#Fedora
sudo dnf install xarchiver

# Lightweight image viewer
#Arch
sudo pacman -S nsxiv

# Debian/Ubuntu
sudo apt install nsxiv

#Fedora
sudo dnf install nsxiv

# -------------------------------------------------
# Useful checks
# -------------------------------------------------

# GNOME check
gnome-shell --version

# Systemd check
systemctl --version

# Checking user services
systemctl --user list-units --type=service
# -------------------------------------------------
# Bottom line
# -------------------------------------------------

# After GNOME + systemd optimization:
# -RAM after login ~850-1200 MB
# -fewer background daemons
# -faster start of GNOME Shell
# -less CPU wakeups
# -smooth Wayland
# -GTK4 fast response
# -less I/O activity

# This saves:
# -PipeWire
# -Wayland
# -hardware acceleration
# -HiDPI
# -normal GNOME compatibility