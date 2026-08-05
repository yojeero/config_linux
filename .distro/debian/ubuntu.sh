
# ----------------------------------
# ubuntu server to desktop
# ----------------------------------

sudo apt update && sudo apt upgrade -y

# ----------------------------------
# remove snap
# ----------------------------------
snap list
sudo snap remove --purge имя_пакета
sudo apt purge snapd -y

rm -rf ~/snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd

# Block re-installation of Snap
sudo nano /etc/apt/preferences.d/nosnap.pref

Package: snapd
Pin: release a=*
Pin-Priority: -10

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

# ----------------------------------
# LAN
# ----------------------------------
# Ubuntu Server uses server Netplan, controlled via YAML files in
 /etc/netplan/

# ----------------------------------
# x11
# ----------------------------------
sudo apt install --no-install-recommends xorg git wget curl

sudo apt install --no-install-recommends spectrwm 

sudo apt install --no-install-recommends alacritty rofi picom feh maim slop xclip dunst i3lock-color 

chmod +x ~/.config/spectrwm/bar_action.sh
chmod +x ~/.config/spectrwm/.spectrwm.conf

echo "exec spectrwm" > ~/.xinitrc

startx

# ----------------------------------
# wayland
# ----------------------------------
sudo apt install --no-install-recommends sway swaybg swaylock swayidle swaylock-effects \
        foot waybar fuzzel picom \
        wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# Launch Wayland sessions, explicitly specifying the backend for the libraries
nano ~/.profile

export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1 # Для Firefox

# ----------------------------------
# autostart scipt
# ----------------------------------
nano ~/.bash_profile

# If this is an interactive session and we are on the first virtual console (TTY1)
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    
    echo "---------------------------------------"
    echo " Выберите графическое окружение:"
    echo " 1) River (Wayland)"
    echo " 2) Spectrwm (X11)"
    echo " 3) Остаться в консоли (TTY)"
    echo "---------------------------------------"
    read -p "Ваш выбор [1-3]: " choice

    case $choice in
        1)
            export XDG_SESSION_TYPE=wayland
            export XDG_CURRENT_DESKTOP=river
            export MOZ_ENABLE_WAYLAND=1
            
# Launch River (via dbus for PipeWire integration)
            exec dbus-run-session river
            ;;
        2)
# Start an X11 session (calls your ~/.xinitrc)
            exec startx
            ;;
        *)
           echo "We remain in the console. To start graphics, reboot the session."
            ;;
    esac
fi

# ----------------------------------
# launch Spectrwm (X11)
# ----------------------------------
nano ~/.xinitrc

#!/bin/sh

# Export variables for X11 graphics
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=spectrwm

# Integration with system dbus (critical for PipeWire)
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

# Launch background utilities
mpd &               
picom --vsync &     

exec spectrwm

chmod +x ~/.xinitrc

# ----------------------------------
# launch River (Wayland)
# ----------------------------------
mkdir -p ~/.config/river

# Running MPD in a Wayland session
riverctl spawn "mpd"

# Setting environment variables within a session
riverctl spawn "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

chmod +x ~/.config/river/init


# ----------------------------------
# To install Firefox as a .deb package
# ----------------------------------

# Add the official Mozilla repository
sudo add-apt-repository ppa:mozillateam/ppa -y

# set priority for the PPA so that the system takes Firefox from there
sudo nano /etc/apt/preferences.d/mozilla-firefox

Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

sudo apt update && sudo apt install firefox -y

# ----------------------------------
# mpd ncmpcpp
# ----------------------------------

# ncmpcpp (NCurses Music Player Daemon Client Plus Plus) -console audio player. 
# To make it play, we need to install and configure MPD (Music Player Daemon) -a background server that will play music and send sound to our configured PipeWire.
sudo apt install --no-install-recommends mpd ncmpcpp

# By default, Ubuntu runs MPD as a global system service, which often causes problems accessing user audio cards. We will disable the system daemon and configure it locally for your user.
sudo systemctl stop mpd
sudo systemctl disable mpd

# We will create directories for configs, playlists and the music itself in your home directory
mkdir -p ~/.config/mpd ~/.local/share/mpd/playlists ~/Music

# look in config
nano ~/.config/mpd/mpd.conf

# run buy user
mpd

# Let's create a configuration file to beautifully display the playlist and enable the built-in spectral visualizer
mkdir -p ~/.config/ncmpcpp
nano ~/.config/ncmpcpp/config

# mpd ncmpcpp using
# 1. copy yours .mp3 or .flac in folder ~/Music.
# 2. ncmpcpp
# 3. Press the u (English) key to refresh the MPD database and see your tracks.

# Basic hotkeys in ncmpcpp:
# 1 - Current playlist.
# 2 - File browser (browsing through folders in ~/Music). 
# Press Space to add the song/folder to the queue.
# 8 — Sound visualizer (same spectrogram).
# Enter -Play the selected track.
# s — Stop, 
# p -Pause.
# > /< — Next /previous track.
# q -Exit ncmpcpp (music will continue to play in the background, since MPD is a daemon).

