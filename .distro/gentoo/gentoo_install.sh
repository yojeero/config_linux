# ----------------------------------
# Gentoo systemd (Binary / MBR / Greetd / Spectrwm)
# ----------------------------------

# Checking disks
lsblk

sudo su

# Completely clearing the partition table and wiping the MBR sector
sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# Automatic fdisk partitioning (MBR: 1GB boot, 50GB root)
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

# Formatting partitions in ext4
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# --------------------------------------------
# Mounting and unpacking Stage3
# --------------------------------------------
mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

# unpack stage from USB
cd /mnt/gentoo

tar xpvf /media/live/Verbatim/TUX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner

ls /mnt/gentoo

# must be
bin
etc
usr
var
lib

# month day time year
date 072713202026

# ----------------------------------
# repo + make.conf
# ----------------------------------
nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe -march=sandybridge"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

FEATURES="${FEATURES} getbinpkg parallel-fetch"
EMERGE_DEFAULT_OPTS="--ask --verbose --with-bdeps=y"

VIDEO_CARDS="intel"
INPUT_DEVICES="libinput"
MAKEOPTS="-j8"

# КРИТИЧНО: Используем флаг systemd вместо elogind
USE="X systemd udev alsa pulseaudio vaapi"

GENTOO_MIRRORS="https://distfiles.gentoo.org"

# ----------------------------------
# repo
# ----------------------------------
mkdir -p /mnt/gentoo/etc/portage/repos.conf

nano /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://rsync.gentoo.org/gentoo-portage
auto-sync = yes

# ----------------------------------
# binrepo
# ----------------------------------
mkdir -p /mnt/gentoo/etc/portage/binrepos.conf

nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf

[binhost]
sync-uri = https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/

# ----------------------------------
# DNS 
# ----------------------------------
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
# Login to Chroot environment
# ----------------------------------
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

# sync repo

# emerge-webrsync
emerge --sync

# Select profile (Desktop OpenRC)
eselect profile list | less

# exit the sheet -q

eselect profile set 4

env-update && source /etc/profile

# chroot
export PS1="(chroot) $PS1"

# ----------------------------------
# Kernel + GRUB
# ----------------------------------
mkdir -p /etc/portage/package.use

echo "sys-kernel/installkernel systemd dracut grub" >> /etc/portage/package.use/installkernel

emerge --ask sys-boot/grub sys-kernel/dracut sys-kernel/installkernel

# Localization configuration for initramfs
mkdir -p /etc/dracut.conf.d
echo 'i18n_vars="LANG=ru_RU.UTF-8 KEYMAP=ru FONT=cyr-sun16"' > /etc/dracut.conf.d/i18n.conf

# Licenses for firmware
echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" >> /etc/portage/package.license
echo "sys-firmware/intel-microcode intel-ucode" >> /etc/portage/package.license

# Kernel
emerge --ask sys-kernel/linux-firmware sys-firmware/intel-microcode
emerge --ask sys-kernel/gentoo-kernel-bin

# Checking the kernel
find /boot -maxdepth 1 -type f

# Grub
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

grep -E "linux|initrd" /boot/grub/grub.cfg

# ----------------------------------
# fstab
# ----------------------------------
blkid

nano /etc/fstab

UUID="9f5984e6-fc67-4425-ae3c-d1babf0f4fe2" /boot  ext4  noatime  1 2
UUID="4ffa5872-1d1d-4c9b-926e-bb7a636422f6" /      ext4  noatime  0 1

# /dev/sda1   /boot        ext4    noatime         1 2
# /dev/sda2   /            ext4    noatime         0 1

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

# chroot
export PS1="(chroot) $PS1"

# ----------------------------------
# host + NetworkManager
# ----------------------------------
echo "gentoo" > /etc/hostname

cat > /etc/hosts << EOF
127.0.0.1 localhost
127.0.1.1 gentoo.localdomain gentoo
::1 localhost
EOF

mkdir -p /etc/portage/package.use
echo "net-misc/networkmanager wifi" >> /etc/portage/package.use/networkmanager

emerge --ask --getbinpkg net-misc/networkmanager net-wireless/iwd net-misc/dhcpcd

systemctl enable NetworkManager
systemctl enable iwd

# ----------------------------------
# X11 graphics server 
# ----------------------------------
emerge --ask sys-apps/dbus app-admin/sudo

systemctl enable dbus

visudo
%wheel ALL=(ALL:ALL) ALL

emerge --ask --getbinpkg x11-base/xorg-server media-libs/mesa x11-drivers/xf86-input-libinput

echo "media-fonts/nerdfonts ~amd64" >> /etc/portage/package.accept_keywords

emerge --ask --getbinpkg media-fonts/jetbrains-mono media-fonts/nerdfonts media-fonts/adwaita-fonts

# ----------------------------------
# Install Greetd
# ----------------------------------
emerge --ask gui-libs/greetd gui-apps/tuigreet sys-boot/os-prober

systemctl enable greetd

# ----------------------------------
# Greetd (Tuigreet) + Spectrwm
# ----------------------------------
mkdir -p /usr/share/xsessions

cat << 'EOF' > /usr/share/xsessions/spectrwm.desktop
[Desktop Entry]
Name=spectrwm
Comment=Spectrwm Window Manager
Exec=spectrwm
Type=Application
EOF

chmod 644 /usr/share/xsessions/spectrwm.desktop

# Конфигурация greetd
nano /etc/greetd/config.toml

[terminal]
vt = 7

[default_session]
command = "tuigreet --time --remember --sessions /usr/share/xsessions"
user = "greetd"

# ----------------------------------
# Connecting third-party repositories (GURU)
# ----------------------------------
emerge --ask app-eselect/eselect-repository dev-vcs/git
eselect repository enable guru
emaint sync -r guru

# ----------------------------------
# spectrwm
# ----------------------------------
git clone https://github.com/Y-Forks/spectrwm
cd spectrwm
make
sudo make install

emerge --ask --getbinpkg \
    x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar \
    media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# pkgs
emerge --ask --getbinpkg www-client/firefox x11-terms/kitty app-editors/mousepad
emerge --ask --getbinpkg xfce-base/thunar xfce-extra/thunar-archive-plugin xfce-base/thunar-volman
emerge --ask --getbinpkg sys-process/bottom app-misc/fastfetch app-misc/mc app-arch/file-roller
emerge --ask --getbinpkg app-arch/7zip app-arch/unzip app-arch/zip app-arch/ouch
emerge --ask --getbinpkg net-misc/wget net-misc/curl gnome-base/gvfs sys-fs/udisks sys-fs/ntfs3g
emerge --ask --getbinpkg dev-libs/glib sys-apps/ripgrep sys-apps/zoxide xfce-extra/xfce4-screenshooter
emerge --ask --getbinpkg media-video/celluloid media-sound/rhythmbox media-gfx/imagemagick media-video/ffmpeg media-gfx/imv
emerge --ask --getbinpkg x11-misc/lxappearance x11-themes/kvantum x11-misc/qt6ct x11-apps/xsetroot

# ----------------------------------
# user
# ----------------------------------
passwd

# Создаем пользователя yopy. В группу seat добавлять НЕ нужно.
useradd -m -G wheel,audio,video,input,plugdev -s /bin/bash yopy
passwd yopy

# ----------------------------------
# unmount
# ----------------------------------
exit
umount -R /mnt/gentoo
reboot
