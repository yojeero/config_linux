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

# узнать размер кэша:
du -sh /var/cache/pacman/pkg/

# установка утилиты paccache
sudo pacman -S pacman-contrib

# очистка кэша, удалить все кэшированные пакеты, кроме 3 последних для каждого пакета
sudo paccache -r

# удалим все кэшированные пакеты, но оставим по две последних версии
sudo paccache -rk2

# удалить все кэшированные пакеты, которых уже нет в системе
sudo paccache -ruk0

# можно создать хук который сам будет после обновлений очищать кэш
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

# И в /etc/pacman.conf раскоментировать строку
HookDir = /etc/pacman.d/hooks/

# встроенная утилита очистки кэша
# удалит кеш пакетов, оставив последние версии
sudo pacman -Sc

# удалит кеш всех пакетов 
sudo pacman -Scc