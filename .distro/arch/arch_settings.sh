
# ----------------------------------
# ssd trim
# ----------------------------------

sudo systemctl enable --now fstrim.timer

# --------------------------------------------
# TIME
# --------------------------------------------

timedatectl set-ntp true
date

# date MMDDhhmmYYYY
date 060201012026

# list
sudo pacman -Qe # list installed packagers
sudo pacman -Qqe > package_list.txt # list packages to list

# drivers
sudo pacman -Sy xf86-video-intel # Intel Graphics Drivers
sudo pacman -S xf86-video-nouveau # Nvidia Graphics Drivers
sudo pacman -Sy nvidia nvidia-utils # Nvidia (proprietary) drivers
sudo pacman -Sy xf86-video-ati # ATI graphics drivers
sudo pacman -Sy xf86-video-vesa # VESA drivers
sudo pacman -Ss xf86-video # full list of available open source drivers

# view video card
lspci -v
lspci -v|grep -i vga
lsmod|grep -i vid

# wifi drivers
lspci -k
lsusb -v
lsusb

# cache
sudo pacman -S pacman-contrib # cache util
sudo paccache -r # clear cache, remove all cached packages except the last 3 for each package
sudo paccache -rk2 # delete all cached packages, but leave the two latest versions
sudo paccache -ruk0 # remove all cached packages that are no longer in the system
sudo pacman -Sc # will remove the package cache, leaving the latest versions
sudo pacman -Scc # will delete the cache of all packages
du -sh /var/cache/pacman/pkg/ # cache size

# you can create a hook that will clear the cache after updates
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = Purning package cache...
When = PostTransaction
Exec = /usr/bin/paccache -rk2

HookDir = /etc/pacman.d/hooks/ # And in /etc/pacman.conf uncomment the line

# ----------------------------------
# XFCE error
# ----------------------------------

# Open a terminal Ctrl+Alt+T or via TTY
xfce4-panel -r
xfdesktop --reload

# Reset xfdesktop settings (desktop is gone)
xfconf-query -c xfce4-desktop -R -r
xfdesktop &

# This will remove all XFCE settings (panel, themes, hotkeys)
mv ~/.config/xfce4 ~/.config/xfce4.backup

xfce4-session-logout

# If the panel is missing
rm -rf ~/.config/xfce4/panel
xfce4-panel &

# Sometimes the problem is broken themes
sudo pacman -S adwaita-icon-theme

# If the screen is completely blank, restart XFCE
startxfce4

# or
xfdesktop &
xfce4-panel &
