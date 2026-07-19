# ----------------------------------
# Bios Legacy + MBR
# ----------------------------------

# --------------------------------------------
# DISK PARTITIONING
# --------------------------------------------
cfdisk 
MBR, 1GB ext4 boot, 50GB root/data

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

# Распаковка без копирования
tar xpvf /mnt/usb/TUX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo

# Обычное копирование
cp /mnt/usb/TUX/stage3.tar.xz /mnt/gentoo/
cd /mnt/gentoo
tar xpvf stage3.tar.xz --xattrs-include='*.*' --numeric-owner

# ----------------------------------
# time
# ----------------------------------
date

# месяц, число, час, минута, год. 
date 071910542026

# ----------------------------------
# repo + make.conf
# ----------------------------------
nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe -march=sandybridge"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

FEATURES="${FEATURES} getbinpkg"
EMERGE_DEFAULT_OPTS="--with-bdeps=y"

VIDEO_CARDS="intel iris"
INPUT_DEVICES="libinput"

USE="X xorg elogind udev alsa -systemd -swap jpeg png gif mp3 mp4 mpeg flac opus vorbis vaapi x264 x265 pulseaudio"

GENTOO_MIRRORS="https://fau.de https://mirror.hs-esslingen.de/Mirrors/gentoo/"

mkdir -p /mnt/gentoo/etc/portage/repos.conf

nano /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://rsync.de.gentoo.org/gentoo-portage
auto-sync = yes

mkdir -p /mnt/gentoo/etc/portage/binrepos.conf

nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf
[gentoo]
priority = 9999
sync-uri = https://fau.de

# Настраиваем DNS для гарантированного интернета внутри chroot
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
nano /mnt/gentoo/etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8

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
# license
# ----------------------------------
mkdir -p /etc/portage/package.license
echo "www-client/google-chrome google-chrome" >> /etc/portage/package.license/custom
echo "app-editors/vscode MIT Microsoft-vscode" >> /etc/portage/package.license/custom

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
emerge --sync

eselect profile list | less

# выйти из листа - q

# [3]   default/linux/amd64/23.0/desktop (stable)
# [7]   default/linux/amd64/23.0/desktop/plasma (stable)

# 1. Устанавливаем профиль (например, 28)
eselect profile set 7

# 2. Обновляем переменные окружения (критически важно!)
env-update && source /etc/profile

export PS1="(chroot) $PS1"

# ----------------------------------
# если сбросилась системная переменная путей PATH
# ----------------------------------
PATH="/usr/bin:/usr/sbin:/bin:/sbin"
source /etc/profile

# если не в chroot - войти опять

# ----------------------------------
# kernel
# ----------------------------------
emerge --ask sys-kernel/gentoo-kernel-bin

# ----------------------------------
# fstab
# ----------------------------------
nano /etc/fstab

/dev/sda1   /boot        ext4    noatime         1 2
/dev/sda2   /            ext4    noatime         0 1

# ----------------------------------
# local
# ----------------------------------
echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

nano /etc/locale.gen

en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8

locale-gen

eselect locale set en_US.utf8

env-update && source /etc/profile

# проверим, где находитесь
ls /

# Если вы видите папки lost+found, boot, home — вы внутри chroot.
# Если вы видите папки mnt, cdrom, rofs — вы случайно вышли наружу.
export PS1="(chroot) $PS1"

# ----------------------------------
# Графический сервер X11 (БЕЗ xf86-video-intel!)
# ----------------------------------
emerge --ask --getbinpkg x11-base/xorg-server media-libs/mesa

# ----------------------------------
# Установка оконного менеджера и окружения (добавлен флаг --getbinpkg)
# ----------------------------------
emerge --ask --getbinpkg x11-wm/spectrwm x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# Если Portage выдаст ошибку "keyword changes are needed", выполните перед установкой авторазблокировку

# Автоматически добавляет нужные пакеты в unmask
emerge --autounmask=y --autounmask-write x11-misc/polybar x11-misc/picom

# Применяет изменения в конфигурационных файлах Portage
etc-update --auto

emerge --ask x11-misc/ly

ls /etc/init.d/

ln -s /etc/init.d/agetty /etc/init.d/agetty.tty2

nano /etc/conf.d/agetty.tty2
agetty_options="--skip-login --login-program /usr/bin/ly"

rc-update add agetty.tty2 default

# ----------------------------------
# Установим elogind для управления сессиями 
# ----------------------------------
emerge --ask sys-auth/elogind
rc-update add elogind boot

# ----------------------------------
# Установка и настройка GRUB (Legacy MBR)
# ----------------------------------

# 1. Прописываем платформу для компиляции/проверки бинарника GRUB (для надежности)
nano /etc/portage/package.use/grub

sys-boot/grub GRUB_PLATFORMS="pc"

# 2. Устанавливаем сам пакет GRUB
emerge --ask --getbinpkg sys-boot/grub:2

# 3. Инсталлируем загрузчик в MBR диска /dev/sda (указываем САМ ДИСК, а не раздел sda1)
grub-install --target=i386-pc /dev/sda

# 4. Генерируем конфигурационный файл меню загрузки
grub-mkconfig -o /boot/grub/grub.cfg

# ----------------------------------
# network (NetworkManager)
# ----------------------------------
# Включаем поддержку Wi-Fi на будущее (лишним не будет, если решите подключить)
mkdir -p /etc/portage/package.use

nano /etc/portage/package.use/networkmanager
net-misc/networkmanager wifi

# Устанавливаем NetworkManager из бинарных пакетов
emerge --ask --getbinpkg net-misc/networkmanager

# проверить название
ls /etc/init.d/ | grep -i network

# Добавляем в автозагрузку OpenRC
rc-update add NetworkManager default

# ----------------------------------
# user
# ----------------------------------
passwd

yopy=1231231

useradd -m -G wheel -s /bin/bash username

passwd username

# Добавляем вашего пользователя в группу для управления сетью без root
usermod -aG plugdev username

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
