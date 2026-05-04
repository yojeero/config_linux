# GGentoo systemd + Sway Wayland + binpkg

# MBR
lsblk

cfdisk /dev/sda

1G	vfat boot	     /boot 
50G	ext4 Linux root   / 

# format
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# mount
mount /dev/sda2 /mnt/gentoo
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/gentoo/boot

# disk info
sudo fdisk -l /dev/sda

# Stage3
cd /mnt/gentoo

wget https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-desktop-systemd/*.tar.xz

tar xpvf stage3-*.tar.xz --xattrs-include='*' --numeric-owner

# or local stage3
tar xpvf gentoo.tar.xz --xattrs-include='*.*' --numeric-owner

# make
sudo nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe"
ACCEPT_KEYWORDS="~amd64"

FEATURES="getbinpkg"
EMERGE_DEFAULT_OPTS="--usepkg --binpkg-respect-use=y"

USE="wayland systemd dbus elogind -X"
VIDEO_CARDS="intel"   # или intel / nvidia

# binpkgs
mkdir -p /mnt/gentoo/etc/portage/binrepos.conf

nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf

[gentoo]
priority = 9999
sync-uri = https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/

# DNS
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

# chroot
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev

# Login
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

# sync
emaint sync -r gentoo

# profile
eselect profile set default/linux/amd64/23.0/desktop/systemd

# kernel + firmware
emerge --ask sys-kernel/linux-firmware
emerge --ask sys-kernel/gentoo-kernel-bin

# fstab
nano /etc/fstab
/dev/sda1  /boot  vfat  defaults  0 2
/dev/sda2  /      ext4  noatime   0 1

# lang
nano /etc/locale.gen

en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8

locale-gen
eselect locale set en_US.utf8

# time
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Hostname
echo "gentoo" > /etc/hostname

# network
emerge --ask net-misc/networkmanager
systemctl enable NetworkManager

# base pkgs
emerge --ask app-admin/sudo sys-apps/dbus
systemctl enable dbus

# Sway Wayland
emerge --ask gui-wm/sway x11-terms/foot x11-misc/waybar gui-apps/wl-clipboard media-gfx/grimshot

# GRUB BIOS Legacy 
emerge --ask sys-boot/grub

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# GRUB UEFI
emerge --ask sys-boot/grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Gentoo
grub-mkconfig -o /boot/grub/grub.cfg

# user
passwd

useradd -m -G wheel,video,render,audio,input -s /bin/bash user
passwd user

EDITOR=nano visudo

%wheel ALL=(ALL:ALL) ALL

# start sway

# create file
nano /home/user/.bash_profile
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec sway

# finish
exit

umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

reboot