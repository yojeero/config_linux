# =========================================
# Gentoo systemd / Binary / MBR / Sway 
# Intel Sandy Bridge
# =========================================

# -----------------------------------------
# Variables
# -----------------------------------------

DISK="/dev/sda"
ROOT="/mnt/gentoo"
HOSTNAME="gentoo"
USERNAME="yopy"
TIMEZONE="Europe/Moscow"

# Stage3
STAGE3="/media/live/Verbatim/TUX/stage3.tar.xz"


# =========================================
# 1. Check disk
# =========================================

lsblk

# =========================================
# 2. Partition disk
# =========================================

sudo -i

sgdisk --zap-all "$DISK"
dd if=/dev/zero of="$DISK" bs=1M count=10

sync

# MBR partition table:
# /dev/sda1 = 1G boot
# /dev/sda2 = 50G root

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

sync

# =========================================
# 3. Format
# =========================================

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# =========================================
# 4. Mount
# =========================================

mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

# =========================================
# 5. Stage3
# =========================================

cd /mnt/gentoo

tar xpvf /media/live/Verbatim/TUX/stage3.tar.xz \
    --xattrs-include='*.*' \
    --numeric-owner

# =========================================
# 6. Date
# =========================================

date 072915272026

# =========================================
# 7. make.conf
# =========================================

nano /mnt/gentoo/etc/portage/make.conf

COMMON_FLAGS="-O2 -pipe -march=sandybridge"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

FEATURES="${FEATURES} getbinpkg parallel-fetch"
EMERGE_DEFAULT_OPTS="--ask --verbose --with-bdeps=y"

MAKEOPTS="-j8"

VIDEO_CARDS="intel"
INPUT_DEVICES="libinput"

USE="systemd udev dbus alsa pipewire vaapi"

GENTOO_MIRRORS="https://distfiles.gentoo.org"

# =========================================
# 8. Gentoo repository
# =========================================

mkdir -p /mnt/gentoo/etc/portage/{repos.conf,binrepos.conf}

cat >/mnt/gentoo/etc/portage/repos.conf/gentoo.conf <<EOF
[gentoo]
location=/var/db/repos/gentoo
sync-type=rsync
sync-uri=rsync://rsync.gentoo.org/gentoo-portage
auto-sync=yes
EOF

cat >/mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf <<EOF
[binhost]
sync-uri=https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/
EOF

# =========================================
# 9. DNS
# =========================================

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

cat >/mnt/gentoo/etc/resolv.conf <<EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

# =========================================
# 10. Chroot mounts
# =========================================

mount -t proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

# =========================================
# 11. Enter chroot
# =========================================

chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

# =========================================
# 12. Portage
# =========================================

emerge --sync

eselect profile list | less
eselect profile set default/linux/amd64/23.0/desktop/systemd

env-update
source /etc/profile

mkdir -p \
/etc/portage/package.use \
/etc/portage/package.accept_keywords \
/etc/portage/package.license

# chroot
export PS1="(chroot) $PS1"

# =========================================
# 13. Kernel / firmware / GRUB
# =========================================

echo "sys-kernel/installkernel systemd dracut grub" \
>/etc/portage/package.use/installkernel

echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" \
>/etc/portage/package.license/linux-firmware

echo "sys-firmware/intel-microcode intel-ucode" \
>/etc/portage/package.license/intel-microcode

emerge --ask \
    sys-boot/grub \
    sys-kernel/dracut \
    sys-kernel/installkernel \
    sys-kernel/linux-firmware \
    sys-firmware/intel-microcode \
    sys-kernel/gentoo-kernel-bin

# =========================================
# 14. GRUB BIOS / MBR
# =========================================

grub-install \
    --target=i386-pc \
    --recheck \
    /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

# =========================================
# 15. Fstab
# =========================================

blkid

nano /etc/fstab

UUID="7f787592-31eb-4092-b01d-ba49e9a43eb1"     /boot   ext4    noatime     1 2
UUID="f39e4e5b-3b6f-453e-9168-46fa9e6f3901"     /       ext4    noatime     0 1

# /dev/sda1   /boot   ext4    noatime     1 2
# /dev/sda2   /       ext4    noatime     0 1

# =========================================
# 16. Timezone
# =========================================

echo Europe/Moscow >/etc/timezone

emerge --config sys-libs/timezone-data

# =========================================
# 17. Locale
# =========================================

cat >/etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen
eselect locale set en_US.utf8
env-update
source /etc/profile

# =========================================
# 18. Hostname
# =========================================

echo gentoo >/etc/hostname

# =========================================
# 19. Network
# =========================================

emerge --ask \
    net-misc/networkmanager \
    net-wireless/iwd \

systemctl enable NetworkManager
systemctl enable iwd
systemctl enable dbus

# =========================================
# 20. Sudo
# =========================================

emerge --ask --getbinpkg app-admin/sudo

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# =========================================
# 21. Wayland / Sway USE flags
# =========================================

cat > /etc/portage/package.use/sway <<'EOF'
gui-wm/sway X
gui-libs/wlroots X
EOF

echo "gui-wm/sway X" >> /etc/portage/package.use/sway
echo "gui-libs/wlroots X x11-backend" >> /etc/portage/package.use/sway

# =========================================
# 22. Sway / Wayland
# =========================================

emerge --ask --getbinpkg \
    gui-wm/sway \
    gui-apps/waybar \
    gui-apps/swaylock \
    gui-apps/swayidle \
    gui-apps/swaybg \
    gui-apps/wl-clipboard \
    gui-apps/fuzzel \
    gui-apps/foot \
    gui-apps/mako \
    gui-apps/grim \
    gui-apps/slurp \
    gui-apps/wlogout \
    gui-libs/xdg-desktop-portal-wlr \
    gui-desktop/xdg-desktop-portal-gtk \
    app-misc/nwg-look

# =========================================
# 23. Video + PipeWire
# =========================================

emerge --ask --getbinpkg \
    media-libs/mesa \
    media-libs/libglvnd

emerge --ask --getbinpkg \
    media-video/pipewire \
    media-video/wireplumber \
    media-sound/alsa-utils

# =========================================
# 24. Desktop applications
# =========================================

emerge --ask \
    app-misc/fastfetch \
    www-client/firefox \
    xfce-base/thunar \
    xfce-extra/thunar-archive-plugin \
    xfce-base/thunar-volman \
    xfce-extra/xfce4-screenshooter \
    xfce-base/tumbler \
    app-editors/mousepad \
    app-arch/xarchiver \
    gnome-base/gvfs \
    sys-fs/udisks \
    app-editors/micro \
    app-misc/mc \
    sys-process/btop \
    media-video/celluloid \
    media-gfx/imagemagick \
    x11-libs/gdk-pixbuf \
    media-video/ffmpeg \
    media-video/ffmpegthumbnailer \
    x11-base/xorg-apps \
    media-fonts/noto \
    sys-apps/eza \
    app-shells/fzf \
    sys-apps/fd 

# =========================================
# 25. GURU / Git
# =========================================

emerge --ask --getbinpkg \
    app-eselect/eselect-repository \
    dev-vcs/git

eselect repository enable guru

emaint sync -r guru

# =========================================
# 26. Fish / utilities
# =========================================

emerge --ask --getbinpkg app-shells/fish

chsh -s /usr/bin/fish yopy

# =========================================
# 27. User
# =========================================

passwd

useradd -m \
    -G wheel,audio,video,input,usb,plugdev \
    -s /bin/bash \
    yopy

passwd yopy

# =========================================
# 33. Fish auto-start Sway on tty1
# =========================================

nano ~/.config/fish/config.fish

if test -z "$WAYLAND_DISPLAY"
    and test (tty) = /dev/tty1
    exec sway
end

# =========================================
# 34. Ownership
# =========================================

chown -R yopy:users /home/yopy

# =========================================
# 35. Enable user PipeWire services
# =========================================

loginctl enable-linger yopy

# =========================================
# 36. Final
# =========================================

exit

umount -lR /mnt/gentoo

reboot

# =========================================
# 37. After reboot > Enter to Sway
# =========================================
login
pass
