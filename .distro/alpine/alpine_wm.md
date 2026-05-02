
# ================================
# xfce
# Base Alpine installation via alpine_xfce.sh
# ================================
chmod +x alpine_xfce.sh
./install-xfce.sh

The script assumes that the user has already been created via setup-alpine
chmod +x install-sway.sh
./install-sway.sh
reboot

# ================================
# bspwm
# Base Alpine installation via alpine_bspwm.sh
# ================================
chmod +x install-bspwm.sh
./install-bspwm.sh
reboo

# after enter
startx

# black screen / does not start X
startx /usr/bin/bspwm

# Wi-Fi
nmtui

# keyboard ru
# insert in ~/.xinitrc
setxkbmap -layout us,ru -option grp:alt_shift_toggle

# touchpad
apk add xf86-input-libinput

# ================================
# sway
# Base Alpine installation via alpine_sway.sh
# ================================

chmod +x alpine_sway.sh
./install-sway.sh
reboot

# after enter
sway


# if sway does not start
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# enter without root

# look
rc-service seatd status

# and USER in seatd

# Wi-Fi
nmtui

# light
brightnessctl set 50%

