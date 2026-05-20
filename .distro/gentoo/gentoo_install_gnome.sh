# ==========================
# Gentoo Binary Install
# Lenovo Z570 / Legacy BIOS / MBR / Intel
# OpenRC + Gnome
# ==========================

# PARTITIONING (MBR / BIOS)
sudo su
dd if=/dev/zero of=/dev/sda bs=1M count=10
cfdisk /dev/sda
# Create sda1 (1G, boot), sda2 (everything else)

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

mkdir -p /mnt/gentoo/home /mnt/gentoo/tmp

# time
timedatectl set-ntp true

# (20 May 2026 17:30)
date 052017302026

# STAGE3
cd /mnt/gentoo
cp /home/linux/stage3.tar.xz .
# extract
tar xJvpf stage3.tar.xz --xattrs --numeric-owner

# wget https://mirror.init7.net/gentoo/releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-desktop-openrc-20260510T170106Z.tar.xz

# extract
# tar xJvpf stage3-amd64-desktop-openrc-20260510T170106Z.tar.xz --xattrs --numeric-owner

# MAKE.CONF
nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe -march=native"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFFLAGS="${COMMON_FLAGS}"
MAKEOPTS="-j5"

FEATURES="getbinpkg"

VIDEO_CARDS="intel"
INPUT_DEVICES="libinput"
GENTOO_MIRRORS="https://dotsrc.org"
ACCEPT_KEYWORDS="amd64"

GRUB_PLATFORMS="pc"
USE="X gtk dbus elogind networkmanager pulseaudio -dhcpcd"

# CHROOT
mkdir -p /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
# DNS
echo "nameserver 1.1.1.1" > /mnt/gentoo/etc/resolv.conf

mount -t proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev

chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

# sync
emerge-webrsync

# profile
eselect profile list 

# OpenRC desktop profile gnome

eselect profile set default/linux/amd64/23.0/desktop/gnome


# locale
echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

nano /etc/locale.gen
# uncomment
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8

locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# repo
mkdir -p /etc/portage/binrepos.conf
nano /etc/portage/binrepos.conf/gentoobinhost.conf

[gentoobinhost]
priority = 9999
sync-uri = https://dotsrc.org
verify-signature = true

# update system + Kernel
emerge -avuDN @world
emerge sys-kernel/linux-firmware sys-firmware/intel-microcode
emerge sys-kernel/gentoo-kernel-bin

# FSTAB
nano /etc/fstab

/dev/sda1   /boot   ext4    noatime    0 2
/dev/sda2   /       ext4    noatime    0 1

# Hostname
echo "gentoo-z570" > /etc/hostname

# Network

emerge net-misc/networkmanager net-wireless/wpa_supplicant x11-base/xorg-server x11-base/xorg-drivers x11-drivers/xf86-video-intel x11-drivers/xf86-input-libinput mesa x11-apps/mesa-progs media-video/pipewire media-video/wireplumber media-sound/alsa-utils sys-auth/elogind

# gnome desktop

emerge gnome-base/gnome-shell gnome-base/gdm gnome-base/nautilus gnome-base/dconf gnome-extra gnome-tweaks x11-terms/gnome-terminal x11-themes/adwaita-icon-theme 

rc-update add NetworkManager default

# disable Wayland
mkdir -p /etc/gdm

nano /etc/gdm/custom.conf

[daemon]
WaylandEnable=false

# tracker disable
mkdir -p /etc/dconf/db/local.d

nano /etc/dconf/db/local.d/00-tracker

[org/freedesktop/tracker/miner/files]
enable-monitors=false
index-on-battery=false
index-recursive-directories=['&DOCUMENTS', '&MUSIC', '&PICTURES']

# run
dconf update

# remove heavy apps
emerge --depclean \
gnome-software \
epiphany \
totem \
yelp \
gnome-maps \
gnome-music \
gnome-weather \
gnome-photos \
gnome-contacts \
gnome-calendar \
simple-scan \
orca \
rygel \
vino \
malcontent

# faster boot
emerge app-admin/rc-services

# memory optimization
echo "vm.swappiness=10" > /etc/sysctl.d/swappiness.conf

# zram
emerge sys-block/zram-init
rc-update add zram-init boot

# fastest GNOME renderer
nano /etc/environment
MUTTER_DEBUG_DISABLE_TRIPLE_BUFFERING=1
CLUTTER_DEFAULT_FPS=60

# USER
passwd
useradd -m -G wheel,audio,video,input,usb,portage -s /bin/bash USER
passwd USER

# sudo 
EDITOR=nano visudo
# Uncomment 
%wheel ALL=(ALL:ALL) ALL

# Delete the erroneous flag file
rm -f /etc/portage/package.use/grub2

# GRUB os-prober
emerge --ask sys-boot/grub:2 os-prober

# Allow os-prober to search for other OSes (required for GRUB2)
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

# Installation on hard drive
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# services OpenRC
rc-update add dbus default
rc-update add elogind boot
rc-update add NetworkManager default

echo "gdm" > /etc/conf.d/display-manager
rc-update add display-manager default

# for Lenovo
echo "options i915 enable_fbc=1 enable_psr=0" > /etc/modprobe.d/i915.conf

exit

# UNMOUNT
umount -R /mnt/gentoo

reboot

# GNOME optimization after login

# make script / run USER inside GNOME session

nano /home/USER/gnome-optimize.sh

gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.mutter check-alive-timeout 0
gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'never
