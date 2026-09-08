#!/bin/bash

# =========================================
# Gentoo systemd / Binary / MBR / Sway
# Intel Sandy Bridge
# =========================================

set -e

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

echo
echo "!!! WARNING !!!"
echo "THIS WILL ERASE: $DISK"
echo
read -rp "Type YES to continue: " CONFIRM

if [ "$CONFIRM" != "YES" ]; then
    echo "Aborted."
    exit 1
fi


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

fdisk "$DISK" <<EOF
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

mkfs.ext4 -F "${DISK}1"
mkfs.ext4 -F "${DISK}2"


# =========================================
# 4. Mount
# =========================================

mkdir -p "$ROOT"

mount "${DISK}2" "$ROOT"

mkdir -p "$ROOT/boot"

mount "${DISK}1" "$ROOT/boot"


# =========================================
# 5. Stage3
# =========================================

cd "$ROOT"

tar xpvf "$STAGE3" \
    --xattrs-include='*.*' \
    --numeric-owner


# =========================================
# 6. Date
# =========================================

date 072915272026


# =========================================
# 7. make.conf
# =========================================

cat > "$ROOT/etc/portage/make.conf" <<'EOF'

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
    "$ROOT/etc/portage/repos.conf" \
    "$ROOT/etc/portage/binrepos.conf"

cat > "$ROOT/etc/portage/repos.conf/gentoo.conf" <<'EOF'
[gentoo]

location=/var/db/repos/gentoo

sync-type=rsync

sync-uri=rsync://rsync.gentoo.org/gentoo-portage

auto-sync=yes
EOF


cat > "$ROOT/etc/portage/binrepos.conf/gentoo.conf" <<'EOF'
[binhost]

sync-uri=https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64/
EOF


# =========================================
# 9. DNS
# =========================================

cat > "$ROOT/etc/resolv.conf" <<'EOF'
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF


# =========================================
# 10. Chroot mounts
# =========================================

mount -t proc /proc "$ROOT/proc"

mount --rbind /sys "$ROOT/sys"
mount --make-rslave "$ROOT/sys"

mount --rbind /dev "$ROOT/dev"
mount --make-rslave "$ROOT/dev"

mount --bind /run "$ROOT/run"
mount --make-slave "$ROOT/run"


# =========================================
# 11. Enter chroot
# =========================================

chroot "$ROOT" /bin/bash <<'CHROOT'

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

BOOT_UUID=$(blkid -s UUID -o value /dev/sda1)
ROOT_UUID=$(blkid -s UUID -o value /dev/sda2)

cat > /etc/fstab <<EOF
UUID=${BOOT_UUID}    /boot    ext4    noatime    1 2
UUID=${ROOT_UUID}    /        ext4    noatime    0 1
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

set $term foot
set $menu fuzzel


### Keyboard

input * {
    xkb_layout us,ru
    xkb_options grp:alt_shift_toggle
}


### Terminal

bindsym $mod+Return exec $term


### Application launcher

bindsym $mod+d exec $menu


### Kill window

bindsym $mod+Shift+q kill


### Reload Sway

bindsym $mod+Shift+c reload


### Exit Sway

bindsym $mod+Shift+e exec wlogout


### Screenshot

bindsym Print exec grim ~/Pictures/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png

bindsym $mod+Print exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png


### Background

output * bg ~/.config/sway/wallpaper.jpg fill


### Waybar

exec_always waybar


### Notifications

exec mako


### Idle

exec swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 600 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' \
    before-sleep 'swaylock -f'


### Clipboard

# wl-clipboard is available system-wide


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
    /home/yopy/.config/mako


# ==========================================================
# 30. Foot config
# ==========================================================

cat > /home/yopy/.config/foot/foot.ini <<'EOF'

[main]

font=Noto Sans Mono:size=11

[colors]

alpha=0.95

EOF


# ==========================================================
# 31. Waybar config
# ==========================================================

cat > /home/yopy/.config/waybar/config <<'EOF'
{
    "layer": "top",
    "position": "top",

    "modules-left": [
        "sway/workspaces"
    ],

    "modules-center": [
        "clock"
    ],

    "modules-right": [
        "network",
        "pulseaudio",
        "battery"
    ],

    "clock": {
        "format": "{:%H:%M  %d.%m.%Y}"
    },

    "battery": {
        "format": "{capacity}%"
    },

    "network": {
        "format-wifi": "  {essid}",
        "format-ethernet": "󰈀 {ipaddr}",
        "format-disconnected": "󰤮"
    },

    "pulseaudio": {
        "format": "  {volume}%"
    }
}
EOF


# ==========================================================
# 32. Mako
# ==========================================================

cat > /home/yopy/.config/mako/config <<'EOF'

font=Noto Sans 11

default-timeout=5000

max-visible=5

padding=10

border-size=2

border-radius=8

EOF


# ==========================================================
# 33. Fish auto-start Sway on tty1
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
# 34. Ownership
# ==========================================================

chown -R yopy:users /home/yopy


# ==========================================================
# 35. Enable user PipeWire services
# ==========================================================

loginctl enable-linger yopy


# ==========================================================
# 36. Final
# ==========================================================

echo
echo "============================================"
echo " Gentoo Sway installation is ready"
echo "============================================"
echo
echo "Disk:"
lsblk

echo
echo "Fstab:"
cat /etc/fstab

echo
echo "Sway:"
sway --version

echo
echo "Reboot:"
echo
echo "exit"
echo "umount -lR /mnt/gentoo"
echo "reboot"
echo

CHROOT


# =========================================
# 37. Leave chroot
# =========================================

echo
echo "============================================"
echo " CHROOT FINISHED"
echo "============================================"
echo

umount -lR "$ROOT"

sync

echo
echo "Installation complete."
echo "Remove installation media and reboot."
echo

reboot