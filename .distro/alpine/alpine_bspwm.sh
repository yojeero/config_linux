#!/bin/sh
set -e

echo "--------------------------------"
echo " Alpine BSPWM setup"
echo "--------------------------------"

# --------------------------------
# Repo
# --------------------------------=

echo "===> Configure repositories"

cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update
apk upgrade

# --------------------------------
# Base system
# --------------------------------=

echo "===> Install base system"

apk add \
    sudo nano bash \
    dbus elogind polkit-elogind \
    xinit

# --------------------------------=
# Enable services
# --------------------------------

echo "===> Enable services"

rc-update add dbus default
rc-update add elogind default

rc-service dbus start
rc-service elogind start

# --------------------------------
# Xorg
# --------------------------------

echo "===> Install Xorg"

setup-xorg-base

# --------------------------------
# BSPWM environment
# --------------------------------

echo "===> Install BSPWM stack"

apk add \
    bspwm \
    sxhkd \
    rofi \
    feh \
    picom \
    dunst \
    kitty \
    alacritty \
    polybar \
    maim \
    slop \
    xclip

# --------------------------------
# Filesystem / removable devices
# --------------------------------

echo "===> Install filesystem support"

apk add \
    gvfs \
    udisks2 \
    ntfs-3g

# --------------------------------
# Network
# --------------------------------

echo "===> Install networking"

apk add \
    networkmanager \
    network-manager-applet \
    wpa_supplicant

rc-update add networkmanager default
rc-service networkmanager start

# --------------------------------
# Audio
# --------------------------------

echo "===> Install PipeWire"

apk add \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pavucontrol

# --------------------------------
# Fonts
# --------------------------------

echo "===> Install fonts"

apk add \
    font-noto

# --------------------------------
# Laptop support
# --------------------------------

echo "===> Install laptop utilities"

apk add \
    brightnessctl \
    acpi \
    acpid

rc-update add acpid default
rc-service acpid start

# --------------------------------
# Useful applications
# --------------------------------

echo "===> Install applications"

apk add \
    firefox \
    thunar thunar-archive-plugin thunar-volman \
    bottom fastfetch \
    unzip zip gzip \
    yazi alacritty mc \
    ripgrep fd fzf \
    git curl wget \
    mousepad font-terminus 

# --------------------------------
# User setup
# --------------------------------

echo "===> User setup"

printf "Enter username: "
read USERNAME

# user groups
addgroup "$USERNAME" audio || true
addgroup "$USERNAME" video || true
addgroup "$USERNAME" input || true
addgroup "$USERNAME" wheel || true

# sudo
grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers || \
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# --------------------------------
# BSPWM config
# --------------------------------

echo "===> Configure BSPWM"

mkdir -p /home/"$USERNAME"/.config/bspwm
mkdir -p /home/"$USERNAME"/.config/sxhkd
mkdir -p /home/"$USERNAME"/.config/dunst
mkdir -p /home/"$USERNAME"/.config/polybar

# --------------------------------
# bspwmrc
# --------------------------------

cat > /home/"$USERNAME"/.config/bspwm/bspwmrc <<'EOF'
#!/bin/sh

# --------------------------------
# Autostart
# --------------------------------

sxhkd &
nm-applet &
polybar main &

# audio
pipewire &
wireplumber &
pipewire-pulse &

# compositor / notifications
picom --experimental-backends &
dunst &

# wallpaper
feh --bg-scale /usr/share/backgrounds/xfce/xfce-blue.jpg &

# --------------------------------
# BSPWM settings
# --------------------------------

bspc config border_width 0
bspc config window_gap 2
bspc config split_ratio 0.50

bspc config focus_follows_pointer true

bspc monitor -d I II III IV V
EOF

chmod +x /home/"$USERNAME"/.config/bspwm/bspwmrc

# ---------------------------------------------------------
# sxhkdrc
# ---------------------------------------------------------

cat > /home/"$USERNAME"/.config/sxhkd/sxhkdrc <<'EOF'
#
# terminal
#

super + Return
    kitty

#
# app launcher
#

super + d
    rofi -show drun

#
# reload sxhkd
#

super + Escape
    pkill -USR1 -x sxhkd

#
# close window
#

super + q
    bspc node -c

#
# focus windows
#

super + {h,j,k,l}
    bspc node -f {west,south,north,east}

#
# move windows
#

super + shift + {h,j,k,l}
    bspc node -s {west,south,north,east}

#
# fullscreen
#

super + f
    bspc node -t fullscreen

#
# tiled / floating
#

super + space
    bspc node -t floating

#
# restart bspwm
#

super + alt + r
    bspc wm -r
EOF

# --------------------------------
# polybar config
# --------------------------------

cat > /home/"$USERNAME"/.config/polybar/config.ini <<'EOF'
[bar/main]
width = 100%
height = 26

background = #222222
foreground = #dddddd

font-0 = monospace:size=10

modules-left = bspwm
modules-right = date

tray-position = right

[module/bspwm]
type = internal/bspwm

label-focused = %name%
label-focused-background = #444444
label-focused-padding = 1

label-occupied = %name%
label-occupied-padding = 1

label-empty = %name%
label-empty-foreground = #666666
label-empty-padding = 1

[module/date]
type = internal/date
interval = 1

date = %H:%M
EOF

# --------------------------------
# xinit
# --------------------------------

echo "===> Configure startx"

cat > /home/"$USERNAME"/.xinitrc <<'EOF'
exec bspwm
EOF

# --------------------------------
# Permissions
# --------------------------------

echo "===> Fix permissions"

chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.config
chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.xinitrc

# --------------------------------
# Done
# --------------------------------

echo
echo "========================================="
echo " Installation complete"
echo "========================================="
echo
echo "Login as user and run:"
echo
echo "    startx"
echo