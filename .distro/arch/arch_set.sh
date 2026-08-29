
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

