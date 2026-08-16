sudo apt update

usermod -a -G sudo yopy

# ----------------------------------
# gnome clean
# ----------------------------------
sudo apt install gnome-core

sudo apt purge libreoffice* rhythmbox totem gnome-games gnome-maps gnome-weather gnome-contacts gnome-music evolution cheese shotwell gnome-todo simple-scan synaptic yelp gnome-user-docs gnome-tour gnome-sound-recorder gnome-software malcontent-gui gnome-calendar gnome-snapshot gnome-characters

sudo apt autoremove --purge && sudo apt clean

# ----------------------------------
# only gnome + desktop, settings and terminal
# ----------------------------------
sudo apt purge gnome gnome-core
sudo apt install gnome-session gnome-shell gnome-terminal nautilus gnome-control-center gdm3
sudo apt autoremove --purge

# ----------------------------------
# list
# ----------------------------------
dpkg-query -f '${binary:Package}\n' -W

# ----------------------------------
# video driver
# ----------------------------------
sudo apt install libgl1-mesa-dri mesa-vulkan-drivers

# ----------------------------------
# audio PipeWire
# ----------------------------------
sudo apt install --no-install-recommends pipewire pipewire-audio wireplumber pipewire-pulse pipewire-alsa pavucontrol

systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service

pactl info








