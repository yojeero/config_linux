# Gentoo systemd + Sway Wayland + binpkg

# MBR
lsblk

cfdisk /dev/sda

1G	vfat boot	     /boot 
50G	ext4 Linux root   / 

# format
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# mount
mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo
mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

# disk info
sudo fdisk -l /dev/sda

# Stage3
cd /mnt/gentoo

wget https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-desktop-systemd/*.tar.xz

tar xpvf stage3-*.tar.xz --xattrs-include='*' --numeric-owner

# or local stage3
cp gentoo.tar.xz /mnt/gentoo/
cd /mnt/gentoo
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
sudo mkdir -p /mnt/gentoo/etc/portage/binrepos.conf

sudo nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf

[gentoo]
priority = 9999
sync-uri = https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/

# DNS
sudo cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

# chroot
sudo mount --types proc /proc /mnt/gentoo/proc
sudo mount --rbind /sys /mnt/gentoo/sys
sudo mount --make-rslave /mnt/gentoo/sys
sudo mount --rbind /dev /mnt/gentoo/dev
sudo mount --make-rslave /mnt/gentoo/dev

# Login
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

# sync
sudo emerge --sync

# profile
eselect profile list
eselect profile set X  

# world
sudo emerge -avuDN @world

# locale
echo "Europe/Moscow" > /etc/timezone
sudo emerge --config sys-libs/timezone-data

sudo nano /etc/locale.gen
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8

locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# kernel + firmware
sudo emerge --ask sys-kernel/linux-firmware sys-kernel/gentoo-kernel-bin

# fstab
sudo nano /etc/fstab
/dev/sda1  /boot  vfat  defaults  0 2
/dev/sda2  /      ext4  noatime   0 1

# Hostname
echo "gentoo" > /etc/hostname

# network
sudo emerge --ask net-misc/networkmanager
systemctl enable NetworkManager

# base pkgs
sudo emerge --ask app-admin/sudo sys-apps/dbus
systemctl enable dbus

# Sway Wayland
sudo emerge --ask \
        gui-wm/sway x11-terms/ghostty \
        x11-misc/waybar gui-apps/wl-clipboard \
        media-gfx/grimshot

# GRUB BIOS Legacy 
sudo emerge sys-boot/grub

sudo grub-install /dev/sda
sudo grub-mkconfig -o /boot/grub/grub.cfg

# GRUB UEFI
sudo emerge sys-boot/grub

sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Gentoo
sudo grub-mkconfig -o /boot/grub/grub.cfg

# user
passwd

useradd -m -G wheel,video,render,audio,input -s /bin/bash user
passwd user

EDITOR=nano visudo

%wheel ALL=(ALL:ALL) ALL

# start sway

# create file
sudo nano /home/user/.bash_profile
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec sway

# finish
exit

sudo umount -l /mnt/gentoo/dev{/shm,/pts,}
sudo umount -R /mnt/gentoo

sudo reboot