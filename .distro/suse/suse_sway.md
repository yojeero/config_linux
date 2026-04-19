OpenSUSEway

# https://en.opensuse.org/Portal:OpenSUSEway

# OpenSUSEway Desktop Environment (DE):

# greetd with gtkgreet as login manager
# waybar as status bar
# Tumbleweed wallpaper
# Sway#wofi as application launcher
# alacritty as default terminal
# SwayNotificationCenter as notifier
# wob for the sound and brightness indicator
# imv as the image viewer
# mpv as video player
# vifm as ncurses based file manager

sudo zypper in -t pattern openSUSEway

# Enable the greetd login manager (recommended)
sudo systemctl set-default graphical.target

# If you already have an installed login manager (GDM, SDDM, LightDM), you need to disable it first
sudo systemctl disable display-manager

# Finally enable the greetd login manager and reboot
sudo systemctl enable greetd