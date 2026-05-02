#!/bin/sh
set -e

echo "===> Repositories"
cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update
apk upgrade

echo "===> Base system"
apk add sudo nano bash dbus elogind polkit-elogind

rc-update add dbus default
rc-update add elogind default

rc-service dbus start
rc-service elogind start

echo "===> Xorg"
setup-xorg-base

echo "===> BSPWM stack"
apk add bspwm sxhkd xterm \
    polybar rofi feh \
    picom dunst

echo "===> Filesystem & devices"
apk add gvfs udisks2 ntfs-3g

echo "===> Network"
apk add networkmanager network-manager-applet \
    wireless-tools wpa_supplicant

rc-update add networkmanager default
rc-service networkmanager start

echo "===> Audio (PipeWire)"
apk add pipewire wireplumber pipewire-pulse pavucontrol

echo "===> Fonts"
apk add font-noto font-noto-cjk font-noto-emoji

echo "===> Laptop tools"
apk add brightnessctl acpi acpid

rc-update add acpid default
rc-service acpid start

echo "===> User setup"
read -p "Enter username: " USERNAME

addgroup "$USERNAME" video || true
addgroup "$USERNAME" audio || true
addgroup "$USERNAME" input || true

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
addgroup "$USERNAME" wheel

echo "===> BSPWM config"
mkdir -p /home/$USERNAME/.config/bspwm
mkdir -p /home/$USERNAME/.config/sxhkd

cat > /home/$USERNAME/.config/bspwm/bspwmrc <<'EOF'
#!/bin/sh

sxhkd &

# basic settings
bspc config border_width 2
bspc config window_gap 8
bspc config split_ratio 0.5

# monitor setup
bspc monitor -d I II III IV V

# autostart
feh --bg-scale /usr/share/backgrounds/xfce/xfce-blue.jpg &
picom &
dunst &
EOF

chmod +x /home/$USERNAME/.config/bspwm/bspwmrc

cat > /home/$USERNAME/.config/sxhkd/sxhkdrc <<'EOF'
# terminal
super + Return
    xterm

# rofi launcher
super + d
    rofi -show drun

# reload sxhkd
super + Escape
    pkill -USR1 -x sxhkd

# close window
super + q
    bspc node -c

# focus
super + {h,j,k,l}
    bspc node -f {west,south,north,east}
EOF

chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

echo "===> Enable startx"
apk add xinit

cat > /home/$USERNAME/.xinitrc <<'EOF'
exec bspwm
EOF

chown $USERNAME:$USERNAME /home/$USERNAME/.xinitrc

echo "===> Done"
echo "Login as user and run: startx"