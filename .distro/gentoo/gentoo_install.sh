# ============================================
# Gentoo Binary Install (i3 + LightDM)
# Legacy BIOS / MBR / OpenRC
# On every step after chroot look for your command made in chroot
# (chroot) localhost / #
# ============================================

# --------------------------------------------
# DISK PARTITIONING
# --------------------------------------------

sudo su

sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# 1. Disk partition (MBR, 1GB boot, 50GB root/data)
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

# 2. Updating the partition table in the system
partprobe /dev/sda

# 3. Formatting partitions in ext4
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

lsblk

# sudo cfdisk /dev/sda
# /dev/sda1    /boot    1G bootable     ext4
# /dev/sda2  root   /   50G   ext4

# --------------------------------------------
# FILESYSTEMS
# --------------------------------------------

mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

# --------------------------------------------
# TIME
# --------------------------------------------

timedatectl set-ntp true
date

# date MMDDhhmmYYYY
date 060201012026

# --------------------------------------------
# STAGE3 LOCAL
# --------------------------------------------

cd /mnt/gentoo

cp /home/linux/stage3.tar.xz /mnt/gentoo

tar xJvpf stage3.tar.xz --xattrs --numeric-owner

# --------------------------------------------
# STAGE3 WEB
# --------------------------------------------

# wget https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-desktop-openrc-*.tar.xz

# tar xJvpf stage3-amd64-desktop-openrc-*.tar.xz \
#     --xattrs --numeric-owner

# --------------------------------------------
# MAKE.CONF
# --------------------------------------------

cat <<EOF > /mnt/gentoo/etc/portage/make.conf
COMMON_FLAGS="-O2 -pipe -march=native"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"
FCFLAGS="\${COMMON_FLAGS}"
FFLAGS="\${COMMON_FLAGS}"

MAKEOPTS="-j$(nproc)"
VIDEO_CARDS="intel"
INPUT_DEVICES="libinput"
GRUB_PLATFORMS="pc"
ACCEPT_LICENSE="*"

FEATURES="getbinpkg"
USE="X dbus elogind pipewire sound-server policykit -systemd"
EOF

# --------------------------------------------
# DNS
# --------------------------------------------

echo "nameserver 8.8.8.8" > /mnt/gentoo/etc/resolv.conf

# --------------------------------------------
# MOUNTS FOR CHROOT
# --------------------------------------------

mount -t proc /proc /mnt/gentoo/proc

mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys

mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev

mount --rbind /run /mnt/gentoo/run
mount --make-rslave /mnt/gentoo/run

# --------------------------------------------
# CHROOT
# --------------------------------------------

chroot /mnt/gentoo /bin/bash

source /etc/profile
export PS1="(chroot) ${PS1}"

# --------------------------------------------
# PORTAGE
# --------------------------------------------

emerge-webrsync

# --------------------------------------------
# PROFILE
# --------------------------------------------

eselect profile list

eselect profile set default/linux/amd64/23.0/desktop/openrc

# --------------------------------------------
# TIMEZONE
# --------------------------------------------

echo "Europe/Moscow" > /etc/timezone

emerge --config sys-libs/timezone-data

# --------------------------------------------
# LOCALE
# --------------------------------------------

cat <<EOF > /etc/locale.gen
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen

eselect locale set en_US.utf8

env-update && source /etc/profile

# --------------------------------------------
# FSTAB
# --------------------------------------------

cat <<EOF > /etc/fstab
/dev/sda1   /boot   ext4    defaults,noatime     0 2
/dev/sda2   /       ext4    defaults,noatime     0 1
EOF

# --------------------------------------------
# HOSTNAME
# --------------------------------------------

echo "gentoo" > /etc/hostname

# --------------------------------------------
# KERNEL + FIRMWARE + GRUB
# --------------------------------------------

# Configure installkernel to use dracut in backwards compatibility mode (compat)
mkdir -p /etc/portage/package.use
echo "sys-kernel/installkernel dracut" >> /etc/portage/package.use/installkernel

# Prevent dracut from crashing inside chroot (create an empty cmdline file)
touch /etc/cmdline

# Install firmware, binary kernel and GRUB
emerge --binpkg-respect-use=n sys-kernel/linux-firmware sys-kernel/gentoo-kernel-bin sys-boot/grub

# Installing the bootloader in the MBR and generating the config
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

ls -lh /boot

# --------------------------------------------
# NETWORK
# --------------------------------------------

emerge net-misc/networkmanager 

rc-update add NetworkManager default

# --------------------------------------------
# CORE SERVICES
# --------------------------------------------

rc-update add udev default
rc-update add dbus default
rc-update add elogind default

# --------------------------------------------
# USERS & SUDO
# --------------------------------------------

passwd

getent group networkmanager

# Networkmanager and plugdev groups 
useradd -m \
-G wheel,audio,video,input,networkmanager \
-s /bin/bash USER

passwd USER

# Install and immediately configure sudo
emerge app-admin/sudo
mkdir -p /etc/sudoers.d
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
chmod 0440 /etc/sudoers.d/wheel

# --------------------------------------------
# XORG + GPU
# --------------------------------------------

emerge \
    x11-base/xorg-server \
    media-libs/mesa \
    x11-apps/xinit

mkdir -p /etc/X11/xorg.conf.d

cat <<EOF > /etc/X11/xorg.conf.d/20-intel.conf
Section "Device"
    Identifier "Intel Graphics"
    Driver "modesetting"
EndSection
EOF

# --------------------------------------------
# i3 & LIGHTDM ENVIRONMENT
# --------------------------------------------

emerge \
    x11-wm/i3 \
    x11-misc/lightdm \
    x11-themes/lightdm-gtk-greeter \
    x11-misc/xdm \
    x11-terms/kitty \
    x11-misc/dmenu \
    media-fonts/noto \
    media-fonts/noto-emoji \
    media-fonts/dejavu \
    media-fonts/liberation-fonts \
    media-fonts/terminus-font \
    media-fonts/jetbrains-mono \
    media-fonts/fontawesome \
    sys-fs/udisks \
    x11-apps/setxkbmap \
    x11-misc/networkmanager-applet

# --------------------------------------------
# APPS
# --------------------------------------------

emerge \
    x11-terms/xterm \
    app-shells/fish \
    app-arch/p7zip \
    app-arch/unzip \
    app-arch/zip \
    app-arch/tar \
    x11-misc/xclip \
    app-editors/mousepad \
    app-misc/fastfetch \
    sys-process/btop \
    dev-vcs/git \
    net-misc/curl \
    media-gfx/imagemagick \
    media-video/mpv \
    media-gfx/feh \
    sys-apps/plocate \
    gnome-base/dconf

# --------------------------------------------
# i3 CONFIG (Running as root, but paths point to USER)
# --------------------------------------------

# Create a folder structure for the USER user directly
mkdir -p /home/USER/.config/i3
mkdir -p /home/USER/wallpapers

# Copy the default config created by the newly installed i3 package
cp /etc/i3/config /home/USER/.config/i3/config

# Filling the config with autostarts
cat <<EOF >> /home/USER/.config/i3/config

exec --no-startup-id nm-applet
exec --no-startup-id setxkbmap -layout us,ru -option grp:alt_shift_toggle
exec_always --no-startup-id feh --bg-fill ~/wallpapers/skate.jpg
EOF

# Restoring file rights for a regular user
chown -R USER:USER /home/USER/

# --------------------------------------------
# LIGHTDM AUTOSTART
# --------------------------------------------

# Set LightDM as the default display manager
echo 'DISPLAYMANAGER="lightdm"' > /etc/conf.d/xdm
rc-update add xdm default
rc-service dbus start
rc-service elogind start
rc-service xdm start

# LightDM may require greeter configuration

# If the screen remains black after running rc-service xdm start, check
grep greeter-session /etc/lightdm/lightdm.conf

# Add if necessary
nano /etc/lightdm/lightdm.conf

[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3

# i3 check
ls /usr/share/xsessions

# i3.desktop

# --------------------------------------------
# FINALIZE
# --------------------------------------------

exit
sudo umount -R /mnt/gentoo

