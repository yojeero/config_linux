# Simple installing Gentoo from a LiveCD 

mkfs.fat -F 32 /dev/sda1
fatlabel /dev/sda1 ESP
mkfs.btrfs -f /dev/sda2
mkswap /dev/sda3

mkdir /mnt/gentoo
mount /dev/sda2 /mnt/gentoo
swapon /dev/sda3

# unpack rootfs
cd /mnt/gentoo
# https://www.gentoo.org/downloads select init openrc desktop profile 
# select need profile and download via wget and wait until everything unpacks
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

wget https://distfiles.gentoo.org/releases/amd64/autobuil…27T170145Z.tar.xz
tar xpvf stage3-amd64-desktop-openrc-20230827T170145Z.tar.xz --xattrs-include='*.*' --numeric-owner

# setup make.conf 
COMMON_FLAGS="-march=native -O2 -pipe" change this in etc/portage/make.conf using nano and MAKEOPTS="-j4" set the maximum number of threads.
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base/ru how to setup make.conf.

# settings mirror - select region
mirrorselect -i -o >> etc/portage/make.conf 

mkdir --parents etc/portage/repos.conf

cp usr/share/portage/config/repos.conf etc/portage/repos.conf/gentoo.conf

cp --dereference /etc/resolv.conf etc/

mount dev/ proc/ run/ sys/

mount -t proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run

# chroot
chroot /mnt/gentoo /bin/bash

# mount boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# download snapshot
emerge-webrsync

# update ebuild repo
emerge --sync

# create it and add it
nano /etc/portage/package.license

# This is necessary for the video card to support the resolution.
sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE

# Setting the time zone
echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

# local
nano /etc/locale.gen
locale-gen
# uncommnet en_US.UTF-8 UTF-8

nano /etc/hostname
gentoo

nano /etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 gentoo.localdomain gentoo

# installing thelinux-firmware
emerge sys-kernel/linux-firmware

# installing the kernel
emerge sys-kernel/gentoo-kernel-bin

# make fstab - if you want
nano /etc/fstab change to /dev/partition boot 1 /boot/efi vfat defaults,noatime 0 2
/dev/partition swap 3 none swap sw 0 0
/dev/main partition 2 / ext4 noatime 0 1

# internet settings
emerge --ask net-misc/dhcpcd
rc-update add dhcpcd default
rc-service dhcpcd start

# settings root password policy
# need in file /etc/security/passwdqc.conf change min to min=0,0,0,0,0 using nano and now passwd and enter 2 times password
Login:root
Password: (Enter the root password)
root # useradd -m -G users,wheel,audio,video -s /bin/bash erzsebet
root # passwd erzsebet
Password: (Enter the password for erzsebet)
Re-enter password: (Re-enter the password to verify)

emerge grub os-prober efibootmgr
grub-install --recheck /dev/sda # for BIOS systems
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub # for UEFI systems
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
reboot

# next steps after rebooting into the new Gentoo installation
rc-update add elogind default
rc-service elogind start