# list installed packagers
pacman -Qe

# list packages to list
pacman -Qqe > package_list.txt

# view video card used
lspci -v
lspci -v|grep -i vga
lsmod|grep -i vid

# Intel Graphics Drivers
sudo pacman -S xf86-video-intel

# Nvidia Graphics Drivers
sudo pacman -S xf86-video-nouveau

# Nvidia (proprietary) drivers
sudo pacman -S nvidia nvidia-utils

# ATI graphics drivers
sudo pacman -S xf86-video-ati

# VESA drivers
sudo pacman -S xf86-video-vesa

# full list of available open source drivers
sudo pacman -Ss xf86-video

# wifi drivers
lspci -k
lsusb -v
lsusb

# cache size
du -sh /var/cache/pacman/pkg/

# cache util
sudo pacman -S pacman-contrib

# clear cache, remove all cached packages except the last 3 for each package
sudo paccache -r

# delete all cached packages, but leave the two latest versions
sudo paccache -rk2

# remove all cached packages that are no longer in the system
sudo paccache -ruk0

# you can create a hook that will clear the cache after updates
#  /etc/pacman.d/hooks/remove_old_cache.hook

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

# And in /etc/pacman.conf uncomment the line
HookDir = /etc/pacman.d/hooks/

# built-in cache clearing utility
# will remove the package cache, leaving the latest versions
sudo pacman -Sc

# will delete the cache of all packages
sudo pacman -Scc