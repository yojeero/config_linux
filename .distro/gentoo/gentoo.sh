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

ls /mnt/gentoo

# must be
bin
etc
usr
var
lib

# month day time year
date 072216302026

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

USE="X elogind udev alsa pulseaudio vaapi"

GENTOO_MIRRORS="https://distfiles.gentoo.org"

# repo
mkdir -p /mnt/gentoo/etc/portage/repos.conf
nano /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://rsync.gentoo.org/gentoo-portage
auto-sync = yes

# binrepo
mkdir -p /mnt/gentoo/etc/portage/binrepos.conf
nano /mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf

[binhost]
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
export PS1="(chroot) ${PS1}"

# license
mkdir -p /etc/portage/package.license

cat > /etc/portage/package.license/custom <<EOF
www-client/google-chrome google-chrome
app-editors/vscode MIT Microsoft-vscode
EOF

# sync repo

getuto

emerge --sync

# Select profile (Desktop OpenRC)
eselect profile list | less

# exit the sheet -q

eselect profile set X

env-update && source /etc/profile

export PS1="(chroot) $PS1"

# ----------------------------------
# Preparing Bootloader and Kernel Tools
# ----------------------------------
mkdir -p /etc/portage/package.use
echo "sys-kernel/installkernel dracut grub" >> /etc/portage/package.use/installkernel

# First install the bootloader itself, dracut and installkernel automation
emerge --ask sys-boot/grub
emerge --ask sys-kernel/dracut
emerge --ask sys-kernel/installkernel

# Configure dracut to generate localized initramfs
mkdir -p /etc/dracut.conf.d

echo 'i18n_vars="LANG=ru_RU.UTF-8 KEYMAP=ru FONT=cyr-sun16"' > /etc/dracut.conf.d/i18n.conf

# ----------------------------------
# Installing and Building Kernel
# ----------------------------------
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

make defconfig
make menuconfig

# Compiling and installing the kernel.
make -j"$(nproc)"
make modules_install
make install
dracut --force --kver "$(make kernelrelease)"

find /boot -maxdepth 1 -type f

# must be
vmlinuz-6.x.x-gentoo
initramfs-6.x.x-gentoo.img
System.map-6.x.x-gentoo
config-6.x.x-gentoo

# ----------------------------------
# MBR GRUB Installation
# ----------------------------------
find /boot -maxdepth 1 -type f

# If empty, grub cannot be installed.

grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

# Check for file availability
ls -l /boot
find /boot -maxdepth 2 -type f

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
emerge --ask sys-apps/dbus
rc-update add dbus default

emerge --ask --getbinpkg x11-base/xorg-server media-libs/mesa

# ----------------------------------
# Install window manager and environment
# ----------------------------------
emerge --ask --getbinpkg x11-wm/spectrwm x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# ----------------------------------
# Install elogind first
# ----------------------------------
emerge --ask --getbinpkg sys-auth/elogind

rc-update add elogind boot

emerge sudo

visudo

%wheel ALL=(ALL:ALL) ALL

# ----------------------------------
# Install overley repo
# ----------------------------------
emerge --ask app-eselect/eselect-repository

eselect repository enable guru

emaint sync -r guru

emerge --ask dev-vcs/git

nano /etc/wgetrc
# add
prefer-family = IPv4

# driver
emerge linux-firmware sys-firmware/intel-microcode

# ----------------------------------
# Install Greetd Display Manager
# ----------------------------------
emerge --ask gui-libs/greetd gui-apps/tuigreet gui-libs/display-manager-init gui-libs/seatd sys-boot/os-prober

rc-update add seatd boot

rc-service seatd start

mkdir -p /usr/share/xsessions

cat << 'EOF' > /usr/share/xsessions/spectrwm.desktop
[Desktop Entry]
Name=spectrwm
Comment=Spectrwm Window Manager
Exec=dbus-run-session startx
Type=Application
EOF

chmod 644 /usr/share/xsessions/spectrwm.desktop

nano /etc/greetd/config.toml

[terminal]
vt = 7

[default_session]
command = "tuigreet --time --remember --sessions /usr/share/xsessions"
user = "greetd"

nano /etc/conf.d/display-manager

CHECKVT=7
DISPLAYMANAGER="greetd"

rc-update add display-manager default
rc-service display-manager start

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

rc-service NetworkManager start

nmcli general status
nmcli device

# ----------------------------------
# user
# ----------------------------------
passwd

useradd -m -G wheel,audio,video,input,plugdev -s /bin/bash username

passwd username

# ----------------------------------
# Spectrwm + TTY 
# ----------------------------------
# emerge --ask x11-apps/xinit

# su - username
# echo "exec spectrwm" > ~/.xinitrc

# # .bash_profile
# cat << 'EOF' > ~/.bash_profile
# if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
#     exec startx
# fi
# EOF

# ----------------------------------
# Additional useful software installation
# ----------------------------------
emerge --ask --getbinpkg www-client/firefox x11-terms/kitty app-editors/mousepad
emerge --ask --getbinpkg xfce-base/thunar xfce-extra/thunar-archive-plugin xfce-extra/thunar-volman
emerge --ask --getbinpkg sys-process/bottom app-misc/fastfetch app-misc/yazi app-misc/mc app-arch/file-roller
emerge --ask --getbinpkg app-arch/p7zip app-arch/unzip app-arch/zip app-arch/ouch
emerge --ask --getbinpkg net-misc/wget dev-vcs/git net-misc/curl gnome-base/gvfs sys-fs/udisks sys-fs/ntfs3g
emerge --ask --getbinpkg app-misc/xdg-utils dev-libs/glib sys-apps/ripgrep

# ----------------------------------
# Exit chroot and reboot
# ----------------------------------
exit
umount -R /mnt/gentoo
reboot

# ==================================

# pkgs
emerge --ask --getbinpkg sys-apps/zoxide xfce-extra/xfce4-screenshooter
emerge --ask --getbinpkg media-video/celluloid media-sound/rhythmbox
emerge --ask --getbinpkg media-gfx/imagemagick media-video/ffmpeg media-gfx/imv
emerge --ask --getbinpkg x11-misc/lxappearance x11-themes/kvantum x11-misc/qt6ct x11-apps/xsetroot
emerge --ask --getbinpkg media-fonts/jetbrains-mono media-fonts/nerd-fonts media-fonts/adwaita-fonts

# SHELL
emerge --ask --getbinpkg app-shells/fish sys-apps/eza app-shells/fzf sys-apps/fd

# Change the shell for your current user 
# run WITHOUT sudo to change yourself, not root
chsh -s $(which fish)

# vscode chrome
emerge --ask --getbinpkg www-client/google-chrome app-editors/vscode

# ----------------------------------
# bspwm
# ----------------------------------
emerge --ask --getbinpkg x11-wm/bspwm x11-misc/sxhkd x11-misc/rofi x11-misc/picom
emerge --ask --getbinpkg x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim    
emerge --ask --getbinpkg x11-misc/slop x11-misc/xclip