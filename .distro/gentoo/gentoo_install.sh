# ============================================
# Gentoo Binary Install (i3 + Polybar + LightDM)
# Legacy BIOS / MBR / OpenRC
# on every step after chroot look for your command made in chroot
# (chroot) gentoo / #
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

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

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
date 052712342026

# --------------------------------------------
# STAGE3 LOCAL
# --------------------------------------------

cd /mnt/gentoo

cp /home/live/stage3.tar.xz /mnt/gentoo

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

# Включение использования бинарных пакетов
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

emerge -avuDN @world

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
# KERNEL + GRUB
# --------------------------------------------

emerge sys-kernel/linux-firmware
emerge sys-kernel/gentoo-kernel-bin

emerge sys-boot/grub

grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

# --------------------------------------------
# Check Kernel
# --------------------------------------------

ls -l /boot
# You should see files like: vmlinuz-6.x.x-gentoo-dist and initramfs-6.x.x-gentoo-dist.img
# If they are not there, then they remain under the “unmounted” folder in the root.

# Checking integration with installkernel
echo "sys-kernel/installkernel grub" > /etc/portage/package.use/installkernel
emerge -uND @world

# Генерируем конфиг заново
grub-mkconfig -o /boot/grub/grub.cfg

# --------------------------------------------
# NETWORK
# --------------------------------------------

emerge net-misc/networkmanager 

rc-update add NetworkManager default

# --------------------------------------------
# CORE SERVICES
# --------------------------------------------

rc-update add udev default

# --------------------------------------------
# USERS
# --------------------------------------------

passwd

useradd -m \
    -G wheel,audio,video,input,usb,portage,networkmanager,storage \
    -s /bin/bash USER

passwd USER

emerge app-admin/sudo

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

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
# AUDIO
# --------------------------------------------

echo "media-video/pipewire sound-server" \
> /etc/portage/package.use/pipewire

emerge \
    media-video/pipewire \
    media-video/wireplumber \
    media-sound/alsa-utils

# --------------------------------------------
# i3
# --------------------------------------------

mkdir -p /etc/portage/package.license

echo "www-client/firefox-bin Mozilla" \
    >> /etc/portage/package.license/firefox

emerge \
    x11-wm/i3 \
    x11-terms/kitty \
    x11-misc/dmenu \
    x11-misc/polybar \
    x11-misc/picom \
    media-fonts/noto \
    media-fonts/noto-emoji \
    media-fonts/dejavu \
    media-fonts/liberation-fonts \
    media-fonts/terminus-font \
    media-fonts/jetbrains-mono \
    media-fonts/fontawesome \
    xfce-base/thunar \
    xfce-base/thunar-volman \
    xfce-extra/thunar-archive-plugin \
    sys-fs/udisks \
    x11-misc/xdg-user-dirs \
    x11-misc/xdg-utils \
    lxqt-base/lxqt-policykit \
    x11-themes/adwaita-icon-theme \
    www-client/firefox-bin \
    app-shells/bash-completion \
    x11-apps/setxkbmap

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
    sys-fs/udisks \
    media-video/celluloid \
    media-video/ffmpeg \
    media-gfx/imagemagick \
    media-video/mpv \
    media-gfx/feh \
    sys-apps/plocate \
    gnome-base/dconf

# --------------------------------------------
# i3 CONFIG
# --------------------------------------------

su - USER

mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/wallpapers

cp /etc/i3/config ~/.config/i3/config

cat <<EOF >> ~/.config/i3/config

exec --no-startup-id pipewire
exec --no-startup-id pipewire-pulse
exec --no-startup-id wireplumber
exec --no-startup-id lxqt-policykit-agent
exec --no-startup-id nm-applet
exec --no-startup-id thunar --daemon
exec --no-startup-id ~/.config/polybar/launch.sh
exec --no-startup-id picom
exec --no-startup-id setxkbmap -layout us,ru -option grp:alt_shift_toggle
exec_always --no-startup-id feh --bg-fill ~/wallpapers/skate.jpg

EOF

# --------------------------------------------
# polybar
# --------------------------------------------

cat <<EOF > ~/.config/polybar/launch.sh
#!/bin/sh

killall polybar 2>/dev/null

sleep 1

polybar main -c ~/.config/polybar/config.ini &
EOF

cat <<EOF > ~/.config/polybar/config.ini
[bar/main]
width = 100%
height = 28

modules-left = i3
modules-center = date
modules-right = pulseaudio memory cpu wlan

font-0 = Terminus:size=12
font-1 = "Font Awesome 6 Free Solid:size=10"

[module/i3]
type = internal/i3

[module/date]
type = internal/date
interval = 1
date = %H:%M %d.%m.%Y

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = CPU 

[module/memory]
type = internal/memory
interval = 2
format-prefix = RAM 

[module/pulseaudio]
type = internal/pulseaudio

[module/wlan]
type = internal/network
interface = wlp2s0
interval = 3

EOF

chmod +x ~/.config/polybar/launch.sh

# Find out the Wi-Fi interface

ip a

# --------------------------------------------
# GTK
# --------------------------------------------

echo "gtk-theme-name=Adwaita" > ~/.gtkrc-2.0

mkdir -p ~/.config/gtk-3.0

cat <<EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Adwaita
gtk-icon-theme-name=Papirus
EOF

# --------------------------------------------
# LightDM 
# --------------------------------------------

echo "x11-misc/lightdm elogind" \
> /etc/portage/package.use/lightdm

emerge \
    x11-misc/lightdm \
    x11-misc/lightdm-gtk-greeter 

cat <<EOF > /usr/share/xsessions/i3.desktop
[Desktop Entry]
Name=i3
Comment=i3 Window Manager
Exec=i3
Type=Application
EOF

mkdir -p /etc/lightdm

cat <<EOF > /etc/lightdm/lightdm.conf
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
EOF

# --------------------------------------------
# EXIT
# --------------------------------------------

xdg-user-dirs-update

exit

rc-update add dbus default
rc-update add elogind boot
rc-update add lightdm default
rc-update add plocate default

exit

umount -R /mnt/gentoo
reboot

sudo updatedb
