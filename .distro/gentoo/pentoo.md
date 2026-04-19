# Pentoo Linux 


# The NetworkManager service is typically managed through the OpenRC init system.

# 1. Start the service
sudo rc-service NetworkManager start

# 2. Add to startup
sudo rc-update add NetworkManager default

# 3. Check status
rc-service NetworkManager status

# If the service is not installed
sudo emerge --ask net-misc/networkmanager


# 1. Install PipeWire and utilities
sudo emerge --ask media-video/pipewire media-video/wireplumber media-sound/alsa-utils

# 2. Add a user to the audio group
sudo gpasswd -a $USER audio

# After that, log out.

# 3. Запустить PipeWire
pipewire &
wireplumber &

# Or add autoload to autorun via DE/WM.

# bspwm
sudo emerge --ask x11-wm/bspwm x11-misc/sxhkd x11-base/xorg-server x11-apps/xinit x11-apps/xrandr x11-misc/rofi

chmod +x ~/.config/bspwm/bspwmrc

# start via .xinitrc
nano ~/.xinitrc

sxhkd &
exec bspwm

# lightDM
sudo emerge --ask x11-misc/lightdm x11-misc/lightdm-gtk-greeter

sudo rc-update add xdm default

sudo nano /etc/conf.d/xdm

DISPLAYMANAGER="lightdm"

/etc/lightdm/lightdm.conf

[Seat:*]
greeter-session=lightdm-gtk-greeter

# LightDM launches WM via .desktop file

# make
sudo nano /usr/share/xsessions/bspwm.desktop

[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning window manager
Exec=/usr/config/bspwm
Type=Application

# LightDM does NOT launch sxhkd automatically.

~/.xprofile

sxhkd &

sudo /etc/init.d/xdm start

ls /usr/share/xsessions/