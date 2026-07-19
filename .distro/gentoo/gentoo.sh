# ----------------------------------
# Gentoo installing Binary / MBR 
# ----------------------------------

sudo su

# --------------------------------------------
# CLEAR DISK 
# --------------------------------------------
sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# --------------------------------------------
# DISK PARTITIONING cfdisk (MBR, 1GB ext4 boot, 50GB root/data)
# --------------------------------------------
cfdisk 
MBR, 1GB ext4 boot, 50GB root/data

# OR

# ----------------------------------
# Disk partition fdisk (MBR, 1GB ext4 boot, 50GB root/data)
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

# What happens here step by step:
#o -Creates a new empty MBR partition table
# .n -> p -> 1 -> Enter -> +1G -Creates the first 1 GB primary partition (under /boot)
# .a — Makes the first partition bootable (sets the boot flag required for Legacy BIOS)
# .n -> p -> 2 -> Enter -> Enter -Creates a second main partition for the entire remaining space on the disk (under the root /)
# .w -Saves changes and writes the table to disk.

# ----------------------------------
# Updating the partition table in the system
# ----------------------------------
partprobe /dev/sda

# ----------------------------------
# # Formatting partitions in ext4
# ----------------------------------
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# check disk
lsblk

# --------------------------------------------
# Mounting and unpacking Stage3
# --------------------------------------------
mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

cd /mnt/gentoo

# Unpack without copying
tar xpvf /mnt/usb/TUX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo

# Normal copy
cp /mnt/usb/TUX/stage3.tar.xz /mnt/gentoo/
cd /mnt/gentoo
tar xpvf stage3.tar.xz --xattrs-include='*.*' --numeric-owner

# ----------------------------------
# time
# ----------------------------------
date

# month, date, hour, minute, year.
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

# Configure DNS for guaranteed internet inside chroot
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
# Login to Chroot environment
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

# exit the sheet -q

# [3]   default/linux/amd64/23.0/desktop (stable)
# [7]   default/linux/amd64/23.0/desktop/plasma (stable)

# Set the profile (for example, 7)
eselect profile set 7

# Update environment variables (critically important!)
env-update && source /etc/profile

export PS1="(chroot) $PS1"

# ----------------------------------
# if the PATH system variable has been reset
# ----------------------------------
PATH="/usr/bin:/usr/sbin:/bin:/sbin"
source /etc/profile

# if not in chroot, log in again

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

# check where you are
ls /

# If you see the lost+found, boot, home folders, you are inside a chroot.
# If you see the mnt, cdrom, rofs folders, you accidentally went outside.
export PS1="(chroot) $PS1"

# ----------------------------------
# X11 graphics server (WITHOUT xf86-video-intel!)
# ----------------------------------
emerge --ask --getbinpkg x11-base/xorg-server media-libs/mesa

# ----------------------------------
# Install window manager and environment (added --getbinpkg flag)
# ----------------------------------
emerge --ask --getbinpkg x11-wm/spectrwm x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# If Portage gives you a "keyword changes are needed" error, auto-unlock before installing

# Automatically adds the necessary packages to unmask
emerge --autounmask=y --autounmask-write x11-misc/polybar x11-misc/picom

# Applies changes to Portage configuration files
etc-update --auto

emerge --ask x11-misc/ly

ls /etc/init.d/

ln -s /etc/init.d/agetty /etc/init.d/agetty.tty2

nano /etc/conf.d/agetty.tty2
agetty_options="--skip-login --login-program /usr/bin/ly"

rc-update add agetty.tty2 default

# ----------------------------------
# Install elogind to manage sessions
# ----------------------------------
emerge --ask sys-auth/elogind
rc-update add elogind boot

# ----------------------------------
# Installing and configuring GRUB (Legacy MBR)
# ----------------------------------
# Install the GRUB package itself
emerge --ask --getbinpkg sys-boot/grub:2

# Install the bootloader in the MBR of disk /dev/sda
grub-install --target=i386-pc /dev/sda

# Generate boot menu configuration file
grub-mkconfig -o /boot/grub/grub.cfg

# ----------------------------------
# NetworkManager
# ----------------------------------
# Enable Wi-Fi support for the future 
mkdir -p /etc/portage/package.use

nano /etc/portage/package.use/networkmanager
net-misc/networkmanager wifi

# Install NetworkManager from binary packages
emerge --ask --getbinpkg net-misc/networkmanager

# проверить название
ls /etc/init.d/ | grep -i network

# Add OpenRC to startup
rc-update add NetworkManager default

# ----------------------------------
# user
# ----------------------------------
passwd

useradd -m -G wheel -s /bin/bash username

passwd username

# Add your user to the group to manage the network without root
usermod -aG plugdev username

# ----------------------------------
# Exit chroot and reboot
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

# Change the shell for your current user 
# run WITHOUT sudo to change yourself, not root
chsh -s $(which fish)

# Allow licenses for Chrome and VS Code
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
# Run the same command with the auto-unmasking flag
emerge --ask --getbinpkg --autounmask=y --autounmask-write <пакеты>

# Apply the suggested changes to the Portage configuration
etc-update --auto
