# Gentoo systemd + bspwm X11 + binpkg

# MBR

# Проверка имени диска
lsblk

# Запуск утилиты разметки (выберите DOS)
cfdisk /dev/sda
# Создайте два раздела:
# /dev/sda1 — 1G (тип Linux, для /boot)
# /dev/sda2 — Все оставшееся пространство (тип Linux, для /)

# Форматирование разделов
sudo mkfs.ext4 /dev/sda1
sudo mkfs.ext4 /dev/sda2

# Монтирование
sudo mkdir -p /mnt/gentoo
sudo mount /dev/sda2 /mnt/gentoo
sudo mkdir -p /mnt/gentoo/boot
sudo mount /dev/sda1 /mnt/gentoo/boot

# disk info
sudo fdisk -l /dev/sda

# Stage3
cd /mnt/gentoo

# Скачивание актуального архива Stage3 (обязательно с desktop-systemd)
sudo wget https://gentoo.org

# Распаковка
sudo tar xpvf stage3-*.tar.xz --xattrs-include='*' --numeric-owner

# or local stage3
sudo cp gentoo.tar.xz /mnt/gentoo/
sudo cd /mnt/gentoo
sudo tar xpvf gentoo.tar.xz --xattrs-include='*.*' --numeric-owner

# make
sudo nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe"
ACCEPT_KEYWORDS="amd64"

FEATURES="getbinpkg"
EMERGE_DEFAULT_OPTS="--usepkg --binpkg-respect-use=y"

USE="X systemd dbus jpeg png -wayland -elogind"
VIDEO_CARDS="intel"

sudo mkdir -p /mnt/gentoo/etc/portage/binrepos.conf
sudo nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf

[gentoo]
priority = 9999
sync-uri = https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/

# Копирование настроек DNS
sudo cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

# Монтирование системных псевдофайловых систем
sudo mount --types proc /proc /mnt/gentoo/proc
sudo mount --rbind /sys /mnt/gentoo/sys
sudo mount --make-rslave /mnt/gentoo/sys
sudo mount --rbind /dev /mnt/gentoo/dev
sudo mount --make-rslave /mnt/gentoo/dev

# Переход в chroot (обратите внимание: без sudo внутри chroot)
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

# Синхронизация дерева портежей
emerge --sync

# Проверка и выбор правильного профиля (ищите номер с systemd/merged-usr)
eselect profile list
# Установите подходящий номер, например:
default/linux/amd64/23.0/desktop/systemd

emerge --sync

echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

nano /etc/locale.gen
# Раскомментируйте или добавьте строки:
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8

locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# Обновление базовой системы
emerge -avuDN @world --getbinpkg=n

# Принудительная локальная сборка графического драйвера Mesa с флагом amber
echo "media-libs/mesa amber" >> /etc/portage/package.use/mesa
emerge --ask --buildpkg=n media-libs/mesa

# Установка ядра, микрокода, прошивок и dracut для генерации initramfs
emerge --ask --depclean
emerge @preserved-rebuild

emerge --ask sys-kernel/linux-firmware
emerge --ask sys-kernel/gentoo-kernel-bin
emerge --ask sys-kernel/dracut
emerge --ask sys-boot/grub

ls /boot

# Настройка fstab
nano /etc/fstab
# Добавьте строки:
/dev/sda1  /boot  ext4  defaults  0 2
/dev/sda2  /      ext4  noatime   0 1

echo "gentoo-z570" > /etc/hostname

# Установка и активация NetworkManager
emerge --ask net-misc/networkmanager
# systemctl enable NetworkManager

# Системные утилиты
emerge --ask app-admin/sudo sys-apps/dbus x11-base/xorg-server
systemctl enable dbus

emerge --ask \
    x11-wm/bspwm x11-misc/sxhkd \
    x11-terms/alacritty x11-misc/rofi \
    x11-misc/polybar media-gfx/feh \
    x11-misc/picom app-shells/fish \
    www-client/firefox-bin 

# PipeWire Установка аудиосервера
emerge --ask media-video/pipewire media-sound/pipewire-alsa media-sound/wireplumber

mkdir -p /etc/pipewire/pipewire.conf.d
ln -s /usr/share/pipewire/pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

# run service
# systemctl --user enable pipewire pipewire-pulse wireplumber

# grub install
emerge --ask sys-boot/grub os-prober
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg   

passwd

useradd -m -G wheel,video,audio,input -s /bin/bash user
passwd user

# Разрешение использовать sudo для группы wheel
EDITOR=nano visudo
# Раскомментируйте строку: %wheel ALL=(ALL:ALL) ALL

# Переключаемся на обычного пользователя внутри chroot для создания конфигов
su - user

# Создание директорий для конфигурации bspwm
mkdir -p ~/.config/bspwm ~/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
chmod +x ~/.config/bspwm/bspwmrc

# Настройка запуска сессии X11
echo "exec bspwm" > ~/.xinitrc

# Автоматический запуск Иксов при входе на первой виртуальной консоли (TTY1)
nano ~/.bash_profile
# Добавьте в конец файла:
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# сделать исполняемым
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/powermenu
chmod +x ~/.config/polybar/launch.sh

# Выход из сессии пользователя обратно в root chroot
exit

# Выход из chroot
exit

# Размонтирование разделов
sudo umount -l /mnt/gentoo/dev{/shm,/pts,}
sudo umount -R /mnt/gentoo

# Перезагрузка системы
sudo reboot




