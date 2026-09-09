#!/bin/bash

# =========================================
# Gentoo systemd / Binary / MBR / Sway
# Intel Sandy Bridge
# =========================================

# -------------------------------------------
# Variables
# --------------------------------------------

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

sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

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

mkfs.ext4 -F /dev/sda1
mkfs.ext4 -F /dev/sda2


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

cat > "/mnt/gentoo/etc/portage/make.conf" <<'EOF'

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

EOF


# =========================================
# 8. Gentoo repository
# =========================================

mkdir -p \
    "/mnt/gentoo/etc/portage/repos.conf" \
    "/mnt/gentoo/etc/portage/binrepos.conf"

cat > "/mnt/gentoo/etc/portage/repos.conf/gentoo.conf" <<'EOF'
[gentoo]

location=/var/db/repos/gentoo

sync-type=rsync

sync-uri=rsync://rsync.gentoo.org/gentoo-portage

auto-sync=yes
EOF


cat > "/mnt/gentoo/etc/portage/binrepos.conf/gentoo.conf" <<'EOF'
[binhost]

sync-uri=https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/
EOF


# =========================================
# 9. DNS
# =========================================

cat > "/mnt/gentoo/etc/resolv.conf" <<'EOF'
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


# ==========================================================
# 12. Portage
# ==========================================================

emerge --sync

eselect profile list | less

eselect profile set default/linux/amd64/23.0/desktop/systemd

env-update

source /etc/profile

mkdir -p \
    /etc/portage/package.use \
    /etc/portage/package.accept_keywords \
    /etc/portage/package.license


# ==========================================================
# 13. Kernel / firmware / GRUB
# ==========================================================

cat > /etc/portage/package.use/installkernel <<'EOF'
sys-kernel/installkernel systemd dracut grub
EOF

cat > /etc/portage/package.license/linux-firmware <<'EOF'
sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE
EOF

cat > /etc/portage/package.license/intel-microcode <<'EOF'
sys-firmware/intel-microcode intel-ucode
EOF

emerge --ask --getbinpkg \
    sys-boot/grub \
    sys-kernel/dracut \
    sys-kernel/installkernel \
    sys-kernel/linux-firmware \
    sys-firmware/intel-microcode \
    sys-kernel/gentoo-kernel-bin


# ==========================================================
# 14. GRUB BIOS / MBR
# ==========================================================

grub-install \
    --target=i386-pc \
    --recheck \
    /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg


# ==========================================================
# 15. Fstab
# ==========================================================

cat > /etc/fstab <<EOF
/dev/sda1    /boot    ext4    noatime    1 2
/dev/sda2    /        ext4    noatime    0 1
EOF


# ==========================================================
# 16. Timezone
# ==========================================================

echo "Europe/Moscow" > /etc/timezone

emerge --config sys-libs/timezone-data


# ==========================================================
# 17. Locale
# ==========================================================

cat > /etc/locale.gen <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen

eselect locale set en_US.utf8

env-update

source /etc/profile


# ==========================================================
# 18. Hostname
# ==========================================================

echo "gentoo" > /etc/hostname


# ==========================================================
# 19. Network
# ==========================================================

emerge --ask --getbinpkg \
    net-misc/networkmanager \
    net-wireless/iwd

systemctl enable NetworkManager
systemctl enable iwd
systemctl enable dbus


# ==========================================================
# 20. Sudo
# ==========================================================

emerge --ask --getbinpkg app-admin/sudo

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers


# ==========================================================
# 21. Wayland / Sway USE flags
# ==========================================================

cat > /etc/portage/package.use/sway <<'EOF'
gui-wm/sway X
gui-libs/wlroots X
EOF


# ==========================================================
# 22. Sway / Wayland
# ==========================================================

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
    gui-libs/xdg-desktop-portal-gtk \
    app-misc/nwg-look


# ==========================================================
# 23. Video + PipeWire
# ==========================================================

emerge --ask --getbinpkg \
    media-libs/mesa \
    media-libs/libglvnd

emerge --ask --getbinpkg \
    media-video/pipewire \
    media-video/wireplumber \
    media-sound/alsa-utils


# ==========================================================
# 24. Desktop applications
# ==========================================================

emerge --ask --getbinpkg \
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
    media-fonts/noto \
    sys-apps/eza \
    app-shells/fzf \
    sys-apps/fd

# ==========================================================
# 25. GURU / Git
# ==========================================================

emerge --ask --getbinpkg \
    app-eselect/eselect-repository \
    dev-vcs/git

eselect repository enable guru

emaint sync -r guru


# ==========================================================
# 26. Fish / utilities
# ==========================================================

emerge --ask --getbinpkg app-shells/fish

chsh -s /usr/bin/fish yopy


# ==========================================================
# 27. User
# ==========================================================

echo
echo "Set root password:"
passwd

useradd -m \
    -G wheel,audio,video,input,usb,plugdev \
    -s /usr/bin/fish \
    yopy

echo
echo "Set password for yopy:"
passwd yopy


# ==========================================================
# 28. Sway config
# ==========================================================

mkdir -p /home/yopy/.config/sway

cat > /home/yopy/.config/sway/config <<'EOF'

### Variables

set $mod Mod4

### Keyboard

input * {
    xkb_layout us,ru
    xkb_options grp:alt_shift_toggle
}

### Terminal

bindsym $mod+Return exec foot


### Application launcher

bindsym $mod+d exec fuzzel


### Kill window

bindsym $mod+Shift+q kill


### Reload Sway

bindsym $mod+Shift+c reload


exec_always waybar

### Environment

setenv XDG_CURRENT_DESKTOP sway
setenv XDG_SESSION_DESKTOP sway
setenv XDG_SESSION_TYPE wayland

EOF


# ==========================================================
# 29. User directories
# ==========================================================

mkdir -p \
    /home/yopy/Pictures \
    /home/yopy/Screen \
    /home/yopy/.config/foot \
    /home/yopy/.config/waybar \
    /home/yopy/.config/fuzzel \


# ==========================================================
# 30. Waybar config
# ==========================================================

cat > /home/yopy/.config/waybar/config <<'EOF'
{
    "layer": "top",
    "position": "top",

    "modules-left": [
        "sway/workspaces"
    ],

    "modules-right": [
        "clock"
    ],

    "clock": {
        "format": "{:%H:%M  %d.%m.%Y}"
    }

}
EOF


# ==========================================================
# 31. Fish auto-start Sway on tty1
# ==========================================================

cat > /home/yopy/.config/fish/config.fish <<'EOF'

if status is-login
    if test -z "$WAYLAND_DISPLAY"
        if test (tty) = /dev/tty1
            exec sway
        end
    end
end

EOF


# ==========================================================
# 32. Ownership
# ==========================================================

chown -R yopy:users /home/yopy


# ==========================================================
# 33. Enable user PipeWire services
# ==========================================================

loginctl enable-linger yopy


# ==========================================================
# 34. Final
# ==========================================================

sway --version

CHROOT


# =========================================
# 35. Leave chroot
# =========================================

umount -lR /mnt/gentoo

sync

reboot