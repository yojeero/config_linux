# ----------------------------------
# Gentoo OpenRC installing Binary / MBR 
# ----------------------------------

# check disk
lsblk

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

# ----------------------------------
# # Formatting partitions in ext4
# ----------------------------------
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# --------------------------------------------
# Mounting and unpacking Stage3
# --------------------------------------------
mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

# copy stage3 to /mnt/gentoo

# Unpack stage3
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

MAKEOPTS="-j8"

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

# Set the profile (for example, 5)
eselect profile set 3

# Update environment variables
env-update && source /etc/profile

export PS1="(chroot) $PS1"

# ----------------------------------
# Installing and configuring GRUB MBR
# ----------------------------------
emerge --ask --getbinpkg sys-boot/grub:2

mount | grep boot

# Install the bootloader in the MBR of disk /dev/sda
grub-install --target=i386-pc /dev/sda

# ----------------------------------
# kernel
# ----------------------------------

# Problems with the gentoo-kernel-bin binary kernel on a laptop are an absolutely natural result of using a Chinese custom processor on an old chipset. 

# The Gentoo binary kernel is a generalized assembly, which, for the sake of versatility, includes thousands of drivers, modules and specific hacks for modern hardware.
# When this “harvester” tries to initialize on a non-standard Chinese processor (mutant), an instruction conflict occurs, and the system freezes (Kernel Panic) at the boot stage, without even having time to show the logs. 

# For your configuration, compiling your own kernel manually is not just a fad, but the only way to make the laptop work stably.

# ----------------------------------
# Installing kernel sources
# ----------------------------------
emerge --ask sys-kernel/installkernel

echo "sys-kernel/installkernel grub -systemd" >> /etc/portage/package.use/installkernel
emerge --ask sys-kernel/installkernel

emerge --ask sys-kernel/gentoo-sources

# Go to the source directory
cd /usr/src/linux

# ----------------------------------
# localmodconfig
# ----------------------------------
make localmodconfig

# The magic of automation for your hardware

# In order not to configure thousands of items manually, we will force the kernel to look at which drivers a stable Linux Live is using right now.

# The system will analyze all currently running modules: your network, Intel graphics, disk controller and automatically disable everything unnecessary in the Gentoo configuration, leaving only what actually works on your laptop.

# If the script asks questions in the console about new functions, just press Enter.

# ----------------------------------
# Manual tuning for the processor
# ----------------------------------
make menuconfig

Go through the following points and check them:

# - Processor type: Go to Processor type and features -> Processor family. 
# - Instead of Generic x86-64, select Core 2/newer Xeon (this will enable optimization for the Sandy/Ivy Bridge architecture of your processor). 
# - Disabling microcode in the kernel itself: Custom Chinese processors often crash the system if the kernel tries to tightly embed official Intel microcode at an early stage of boot.
# - Check that in Processor type and features the Early firmware loading item is DISABLED (you will uncheck the box). 
# - We will update the microcode later and safely through the bootloader. Intel HD Graphics: Go to Device Drivers -> Graphics support.
# - Make sure that the integrated Intel 8xx/9xx/G3x/G4x/HD Graphics driver is enabled as built-in ([*]) and not as a module (M). 
# - This will protect against a black screen at boot. Save the configuration (Save button) and exit (Exit).

# ----------------------------------
# Compilation and installation
# ----------------------------------
make -j8 && make modules_install && make install

ls -l /boot

# IF WANT Generate boot menu configuration file

# grub-mkconfig -o /boot/grub/grub.cfg
# grep menuentry /boot/grub/grub.cfg

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
# Install elogind to manage sessions
# ----------------------------------
# Install elogind first, since Ly depends on it for session management
emerge --ask --getbinpkg sys-auth/elogind

rc-update add elogind boot

# ----------------------------------
# Install Ly Display Manager
# ----------------------------------
emerge --ask --getbinpkg x11-misc/ly

rc-update add ly default

# ----------------------------------
#  Disabling standard agetty on tty2
# ----------------------------------
nano /etc/inittab

# By default, OpenRC launches classic passport login (console login) on the first six terminals (tty1–tty6).
# Ly is configured to run on tty2 by default. 
# To prevent Gentoo's native agetty from interfering with Ly running on this terminal, you simply need to disable tty2 in the main init config file.

# Find the line responsible for tty2 

# comment it out
c2:2345:respawn:/sbin/agetty 38400 tty2 linux

# When the laptop boots, OpenRC will launch elogind. 
# The ly service is then activated. 
# It will intercept tty2 itself, clear the screen and show the UI for entering your login and password.

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

# проверить название
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
