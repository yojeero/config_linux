# ----------------------------------
# Bios Legacy + MBR
# ----------------------------------

# --------------------------------------------
# DISK PARTITIONING
# --------------------------------------------

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# --------------------------------------------
# DISK PARTITIONING
# --------------------------------------------

sudo su

sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# ----------------------------------
# 1. Disk partition (MBR, 1GB ext4 boot, 50GB root/data)
# ----------------------------------
fdisk /dev/sda <<EOF
o
n
p
1

+1G
a
n
p
2

+50G
w
EOF

# ----------------------------------
# 1. Disk partition (MBR, 1GB ext4 boot, ALL HD root/data)
# ----------------------------------
sudo su

# Полная очистка диска от старых разметок и метаданных
sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# Автоматическая разметка в fdisk
fdisk /dev/sda <<EOF
o
n
p
1

+1G
a
n
p
2


w
EOF

# Что здесь происходит по шагам:
# o — Создает новую пустую таблицу разделов MBR
# .n -> p -> 1 -> Enter -> +1G — Создает первый основной раздел на 1 ГБ (под /boot)
# .a — Делает первый раздел загрузочным (выставляет нужный для Legacy BIOS флаг boot)
# .n -> p -> 2 -> Enter -> Enter — Создает второй основной раздел на всё оставшееся место на диске (под корень /)
# .w — Сохраняет изменения и записывает таблицу на диск.


# 2. Updating the partition table in the system
partprobe /dev/sda

# 3. Formatting partitions in ext4
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

lsblk

# --------------------------------------------
# Монтирование и распаковка Stage3
# --------------------------------------------

mount /dev/sda2 /mnt/gentoo
mkdir /mnt/gentoo/boot

mount /dev/sda1 /mnt/gentoo/boot
cd /mnt/gentoo

# Создаем временную директорию и монтируем туда флешку
mkdir -p /mnt/usb
mount /dev/sdb1 /mnt/usb

# Перед распаковкой обязательно убедитесь, что вы находитесь в корневом разделе вашей новой системы 
cd /mnt/gentoo

# Распаковка архива
tar xpvf /mnt/usb/stage3.tar.xz --xattrs-include='*.*' --numeric-owner

# отмонтировать usb
umount /mnt/usb

# ----------------------------------
# time
# ----------------------------------
date

# месяц, число, час, минута, год. 
date 090615302018

# ----------------------------------
# repo + make.conf
# ----------------------------------
cat << 'EOF' > /mnt/gentoo/etc/portage/make.conf
COMMON_FLAGS="-O2 -pipe -march=sandybridge"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

# Активация бинарного репозитория
FEATURES="getbinpkg binpkg-logs"
EMERGE_DEFAULT_OPTS="--binpkg-respect-use=y"

# Специфика Lenovo Z570
VIDEO_CARDS="intel i965"
INPUT_DEVICES="libinput synaptics"

USE="X xorg elogind udev alsa i915 -swap"
GENTOO_MIRRORS="http://yandex.ru http://itmo.ru"
EOF

# Создаем директорию и записываем файл бинарного зеркала
mkdir -p /mnt/gentoo/etc/portage/binrepos.conf
cat << 'EOF' > /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf
[gentoo]
priority = 9999
sync-uri = http://yandex.ru
EOF

# Настраиваем DNS для гарантированного интернета внутри chroot
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
cat << 'EOF' > /mnt/gentoo/etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

# ----------------------------------
# before Chroot 
# ----------------------------------
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

# ----------------------------------
# Вход в Chroot окружение
# ----------------------------------
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

# ----------------------------------
# world
# ----------------------------------
getuto
emerge-webrsync

# ----------------------------------
# kernel
# ----------------------------------
emerge --ask sys-kernel/gentoo-kernel-bin

# ----------------------------------
# fstab
# ----------------------------------
nano /etc/fstab

/dev/sda1   /boot        ext4    noatime         1 2
/dev/sda2   none         swap    sw              0 0
/dev/sda3   /            ext4    noatime         0 1

# ----------------------------------
# local
# ----------------------------------
echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# ----------------------------------
# driver
# ----------------------------------
emerge --ask x11-base/xorg-server x11-drivers/xf86-video-intel media-libs/mesa

# ----------------------------------
# spectrwm, ly / greetd
# ----------------------------------
emerge --ask --getbinpkg x11-wm/spectrwm x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# Если Portage выдаст ошибку "keyword changes are needed", выполните перед установкой авторазблокировку

# Автоматически добавляет нужные пакеты в unmask
emerge --autounmask=y --autounmask-write x11-misc/polybar x11-misc/picom

# Применяет изменения в конфигурационных файлах Portage
etc-update --auto

emerge --ask x11-misc/ly
rc-update add ly default

# ----------------------------------
# Установим elogind для управления сессиями 
# ----------------------------------
emerge --ask sys-auth/elogind
rc-update add elogind boot

# ----------------------------------
# grub
# ----------------------------------
emerge --ask sys-boot/grub:2
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# ----------------------------------
# network
# ----------------------------------
emerge --ask net-misc/dhcpcd
rc-update add dhcpcd default

mkdir -p /etc/portage/package.use
echo "net-misc/networkmanager wifi" >> /etc/portage/package.use/networkmanager

emerge --ask net-misc/networkmanager

rc-update del dhcpcd default
usermod -aG plugdev username

# ----------------------------------
# user
# ----------------------------------
passwd
useradd -m -G wheel,audio,video,input -s /bin/bash username
passwd username

# ----------------------------------
# Выходим из chroot и перезагружаем
# ----------------------------------
exit
umount -R /mnt/gentoo
reboot

rc-service networkmanager start
nmtui

# ==================================

# pkgs
emerge --ask --getbinpkg \
    www-client/firefox x11-terms/kitty x11-terms/alacritty app-editors/mousepad \
    xfce-base/thunar xfce-extra/thunar-archive-plugin xfce-extra/thunar-volman \
    sys-process/bottom app-misc/fastfetch app-misc/yazi app-misc/mc app-arch/file-roller \
    app-arch/p7zip app-arch/unzip app-arch/zip app-arch/ouch \
    net-misc/wget dev-vcs/git net-misc/curl gnome-base/gvfs sys-fs/udisks sys-fs/ntfs3g \
    app-misc/xdg-utils dev-libs/glib sys-apps/ripgrep sys-apps/zoxide xfce-extra/xfce4-screenshooter \
    media-video/celluloid media-sound/rhythmbox media-gfx/imagemagick media-video/ffmpeg media-gfx/imv \
    x11-misc/lxappearance x11-themes/kvantum x11-misc/qt6ct x11-apps/xsetroot \
    media-fonts/jetbrains-mono media-fonts/nerd-fonts media-fonts/adwaita-fonts


# SHELL
emerge --ask --getbinpkg app-shells/fish sys-apps/eza app-shells/fzf sys-apps/fd

# Смена шелла для вашего текущего пользователя 
# выполнять БЕЗ sudo, чтобы сменить себе, а не руту
chsh -s $(which fish)

# Разрешаем лицензии для Chrome и VS Code
mkdir -p /etc/portage/package.license
echo "www-client/google-chrome google-chrome" >> /etc/portage/package.license/custom
echo "app-editors/vscode MIT Microsoft-vscode" >> /etc/portage/package.license/custom

emerge --ask --getbinpkg www-client/google-chrome app-editors/vscode

# ----------------------------------
# bspwm
# ----------------------------------
emerge --ask --getbinpkg \
    x11-wm/bspwm x11-misc/sxhkd x11-misc/rofi x11-misc/picom \
    x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim \
    x11-misc/slop x11-misc/xclip

# ------------------------------
# если Portage ругается на USE-флаги или маскировку
# ------------------------------
# 1. Запустите ту же команду с флагом авторазмаскирования (например, для первой группы):
emerge --ask --getbinpkg --autounmask=y --autounmask-write <пакеты>

# 2. Примените предложенные изменения в конфигурацию Portage:
etc-update --auto
