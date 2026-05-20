# ==========================
# Gentoo Binary Install
# Lenovo Z570 / Legacy BIOS / MBR / Intel
# OpenRC + Bspwm
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

# OpenRC desktop profile
eselect profile set 4 # select openrc desktop

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

# bspwm 
emerge x11-base/xorg-server x11-drivers/xf86-video-intel x11-drivers/xf86-input-libinput mesa
emerge media-video/pipewire media-video/wireplumber media-sound/alsa-utils
emerge x11-wm/bspwm x11-misc/sxhkd x11-terms/alacritty x11-misc/polybar x11-misc/picom x11-misc/dmenu x11-misc/rofi x11-apps/xinit x11-apps/xrandr media-gfx/feh app-shells/bash-completion www-client/firefox-bin
emerge sys-auth/elogind app-admin/sudo
emerge net-misc/networkmanager net-wireless/wpa_supplicant

rc-update add NetworkManager default

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

# Базовая инициализация конфигов bspwm (Важно, чтобы не было черного экрана)
mkdir -p /home/USER/.config/bspwm /home/USER/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc /home/USER/.config/bspwm/bspwmrc
cp /usr/share/doc/sxhkd/examples/sxhkdrc /home/USER/.config/sxhkd/sxhkdrc
chmod +x /home/USER/.config/bspwm/bspwmrc

# .xinitrc bspwm
cat << 'EOF' > /home/USER/.xinitrc
#!/bin/sh
setxkbmap -layout us,ru -option grp:alt_shift_toggle &

wireplumber &

exec bspwm
EOF
# Configuring X server autostart
cat << 'EOF' > /home/USER/.bash_profile
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi
EOF

chown -R USER:USER /home/USER/
chmod +x /home/USER/.xinitrc

# Services
rc-update add dbus boot
rc-update add elogind boot

# CPU flags
emerge app-portage/cpuid2cpuflags
cpuid2cpuflags >> /etc/portage/make.conf

# Выход
exit
umount -R /mnt/gentoo
reboot