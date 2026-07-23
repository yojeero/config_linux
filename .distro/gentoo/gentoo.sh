# ----------------------------------
# Gentoo OpenRC installing Binary / MBR 
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

# month day time year
date 072216302026

# ----------------------------------
# repo + make.conf
# ----------------------------------
nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe -march=sandybridge"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

FEATURES="${FEATURES} getbinpkg"
EMERGE_DEFAULT_OPTS="--with-bdeps=y"

VIDEO_CARDS="intel"
INPUT_DEVICES="libinput"

MAKEOPTS="-j8"

USE="X xorg elogind udev alsa -systemd -swap jpeg png gif mp3 mp4 mpeg flac opus vorbis vaapi x264 x265 pulseaudio"

GENTOO_MIRRORS="https://yandex.ru https://leaseweb.com"

# repo
mkdir -p /mnt/gentoo/etc/portage/repos.conf
nano /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://rsync.ru.gentoo.org/gentoo-portage
auto-sync = yes

# binrepo
mkdir -p /mnt/gentoo/etc/portage/binrepos.conf
nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf

[binhost]
priority = 9999
sync-uri = https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/

# Configure DNS 
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
export PS1="(chroot) $PS1"

# license
mkdir -p /etc/portage/package.license

echo "www-client/google-chrome google-chrome" >> /etc/portage/package.license/custom
echo "app-editors/vscode MIT Microsoft-vscode" >> /etc/portage/package.license/custom

# sync repo

getuto

emerge --sync

eselect profile list | less

# exit the sheet -q

eselect profile set 3

env-update && source /etc/profile

export PS1="(chroot) $PS1"

# ----------------------------------
# Installing kernel sources
# ----------------------------------
mkdir -p /etc/portage/package.use

echo "sys-kernel/installkernel dracut grub" >> /etc/portage/package.use/installkernel

# GRUB
# emerge --ask sys-boot/grub
emerge --ask sys-kernel/installkernel

# kernel
emerge --ask sys-kernel/gentoo-sources

eselect kernel list
eselect kernel set 1

cd /usr/src/linux

# Export configuration from Live environment
if [ -f /proc/config.gz ]; then
    zcat /proc/config.gz > .config
elif [ -f /boot/config-$(uname -r) ]; then
    cp /boot/config-$(uname -r) .config
else
    make defconfig
fi

make localmodconfig

make menuconfig

make -j$(nproc) && make modules_install && make install

grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

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

# chroot
export PS1="(chroot) $PS1"

# ----------------------------------
# X11 graphics server 
# ----------------------------------
emerge --ask --getbinpkg x11-base/xorg-server media-libs/mesa

# ----------------------------------
# Install window manager and environment (use --getbinpkg flag)
# ----------------------------------
emerge --ask --getbinpkg x11-wm/spectrwm x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# ----------------------------------
# Install elogind first, since Ly depends on it for session management
# ----------------------------------
emerge --ask --getbinpkg sys-auth/elogind

rc-update add elogind boot

# ----------------------------------
# Install overley repo
# ----------------------------------
emerge --ask app-eselect/eselect-repository

eselect repository enable guru

emaint sync -r guru

nano /etc/wgetrc

prefer-family = IPv4

# ----------------------------------
# Install Ly Display Manager
# ----------------------------------
emerge --ask --getbinpkg x11-misc/ly

rc-update add ly default

# ----------------------------------
#  Disabling standard agetty on tty2
# ----------------------------------
nano /etc/inittab

# comment it out
c2:2345:respawn:/sbin/agetty 38400 tty2 linux

# ----------------------------------
# Configure spectrwm session for Ly
# ----------------------------------
mkdir -p /usr/share/xsessions

cat << 'EOF' > /usr/share/xsessions/spectrwm.desktop
[Desktop Entry]
Name=spectrwm
Comment=Speculative Window Manager
Exec=spectrwm
Type=Application
DesktopNames=spectrwm
EOF

chmod 644 /usr/share/xsessions/spectrwm.desktop

# ----------------------------------
# NetworkManager
# ----------------------------------
# Enable Wi-Fi support for the future 
mkdir -p /etc/portage/package.use

nano /etc/portage/package.use/networkmanager
net-misc/networkmanager wifi

# Install NetworkManager from binary packages
emerge --ask --getbinpkg net-misc/networkmanager

# check title
ls /etc/init.d/ | grep -i network

# Add OpenRC to startup
rc-update add NetworkManager default

# Install a lightweight dhcpcd client
emerge --ask --getbinpkg net-misc/dhcpcd

# ----------------------------------
# user
# ----------------------------------
passwd

useradd -m -G wheel -s /bin/bash username

passwd username

# Add user to the group to manage the network
usermod -aG plugdev username

ls -R /boot

find /boot -maxdepth 2 -type f

# ----------------------------------
# Spectrwm + TTY (enter without LY)
# ----------------------------------
echo "exec spectrwm" > ~/.xinitrc

# startx

# at end of the file ~/.bash_profile or .bashrc
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

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
# auto-unmasking flag
# ------------------------------
emerge --ask --getbinpkg --autounmask=y --autounmask-write <пакеты>

# Apply the suggested changes to the Portage configuration
etc-update --auto
