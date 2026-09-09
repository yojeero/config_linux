#!/bin/bash
set -euo pipefail

# ============================================================
# Gentoo automatic installer
# systemd / binary packages / MBR / Sway
# Intel Sandy Bridge
#
# WARNING: /dev/sda will be COMPLETELY ERASED!
# ============================================================

DISK="/dev/sda"
ROOT="/mnt/gentoo"

HOSTNAME="gentoo"
USERNAME="yopy"
TIMEZONE="Europe/Moscow"

STAGE3="/media/live/Verbatim/TUX/stage3.tar.xz"

# ------------------------------------------------------------
# Colors / helpers
# ------------------------------------------------------------

die() {
    echo
    echo "ERROR: $*"
    exit 1
}

info() {
    echo
    echo "============================================================"
    echo "$*"
    echo "============================================================"
}

# ------------------------------------------------------------
# Root check
# ------------------------------------------------------------

[[ $EUID -eq 0 ]] || die "Run this script as root."

# ------------------------------------------------------------
# Check files / disk
# ------------------------------------------------------------

info "Checking environment"

command -v sgdisk >/dev/null || die "sgdisk is not installed."
command -v fdisk  >/dev/null || die "fdisk is not installed."
command -v mkfs.ext4 >/dev/null || die "mkfs.ext4 is not installed."
command -v chroot >/dev/null || die "chroot is not installed."

[[ -f "$STAGE3" ]] || die "Stage3 not found: $STAGE3"
[[ -b "$DISK" ]] || die "Disk not found: $DISK"

echo
echo "Target disk:"
lsblk "$DISK"

echo
read -rp "THIS WILL ERASE $DISK COMPLETELY. Type ERASE to continue: " CONFIRM

[[ "$CONFIRM" == "ERASE" ]] || die "Installation cancelled."

# ------------------------------------------------------------
# Passwords
# ------------------------------------------------------------

info "Passwords"

echo "Set root password:"
read -rsp "Root password: " ROOT_PASSWORD
echo
read -rsp "Repeat root password: " ROOT_PASSWORD2
echo

[[ "$ROOT_PASSWORD" == "$ROOT_PASSWORD2" ]] \
    || die "Root passwords do not match."

echo
echo "Set password for $USERNAME:"
read -rsp "User password: " USER_PASSWORD
echo
read -rsp "Repeat user password: " USER_PASSWORD2
echo

[[ "$USER_PASSWORD" == "$USER_PASSWORD2" ]] \
    || die "User passwords do not match."

# ------------------------------------------------------------
# Unmount old installation
# ------------------------------------------------------------

info "Unmounting old mounts"

umount -R "$ROOT" 2>/dev/null || true

# ------------------------------------------------------------
# Partition disk
# ------------------------------------------------------------

info "Partitioning $DISK"

sgdisk --zap-all "$DISK"

dd if=/dev/zero of="$DISK" bs=1M count=10 status=progress
sync

# MBR:
# /dev/sda1 = 1G boot
# /dev/sda2 = remainder / (approximately 50G on a 51G+ disk)

fdisk "$DISK" <<'EOF'
o
n
p
1

+1G
a
n
p
2


w
EOF

sync
sleep 2

# ------------------------------------------------------------
# Detect partition names
# ------------------------------------------------------------

BOOT_PART="${DISK}1"
ROOT_PART="${DISK}2"

[[ -b "$BOOT_PART" ]] || die "Boot partition not found: $BOOT_PART"
[[ -b "$ROOT_PART" ]] || die "Root partition not found: $ROOT_PART"

# ------------------------------------------------------------
# Format
# ------------------------------------------------------------

info "Formatting partitions"

mkfs.ext4 -F "$BOOT_PART"
mkfs.ext4 -F "$ROOT_PART"

# ------------------------------------------------------------
# Mount
# ------------------------------------------------------------

info "Mounting filesystem"

mkdir -p "$ROOT"

mount "$ROOT_PART" "$ROOT"

mkdir -p "$ROOT/boot"
mount "$BOOT_PART" "$ROOT/boot"

# ------------------------------------------------------------
# Stage3
# ------------------------------------------------------------

info "Installing Stage3"

cd "$ROOT"

tar xpvf "$STAGE3" \
    --xattrs-include='*.*' \
    --numeric-owner

# ------------------------------------------------------------
# Date
# ------------------------------------------------------------

info "Setting date"

# Original value from your script:
# 07/29/2026 15:27
date -s "2026-07-29 15:27:00"

# ------------------------------------------------------------
# make.conf
# ------------------------------------------------------------

info "Creating make.conf"

cat > "$ROOT/etc/portage/make.conf" <<'EOF'
COMMON_FLAGS="-O2 -pipe -march=sandybridge"

CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

FEATURES="getbinpkg parallel-fetch"

EMERGE_DEFAULT_OPTS="--verbose --with-bdeps=y"

MAKEOPTS="-j8"

VIDEO_CARDS="intel"

INPUT_DEVICES="libinput"

USE="systemd udev dbus alsa pipewire vaapi"

GENTOO_MIRRORS="https://distfiles.gentoo.org"
EOF

# ------------------------------------------------------------
# Gentoo repository
# ------------------------------------------------------------

info "Configuring Gentoo repository"

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

# ------------------------------------------------------------
# DNS
# ------------------------------------------------------------

info "Configuring DNS"

cat > "$ROOT/etc/resolv.conf" <<'EOF'
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

# ------------------------------------------------------------
# Chroot mounts
# ------------------------------------------------------------

info "Preparing chroot"

mount -t proc /proc "$ROOT/proc"

mount --rbind /sys "$ROOT/sys"
mount --make-rslave "$ROOT/sys"

mount --rbind /dev "$ROOT/dev"
mount --make-rslave "$ROOT/dev"

mount --bind /run "$ROOT/run"
mount --make-slave "$ROOT/run"

# ------------------------------------------------------------
# Pass variables into chroot
# ------------------------------------------------------------

cat > "$ROOT/root/install-vars" <<EOF
ROOT_PASSWORD='$ROOT_PASSWORD'
USER_PASSWORD='$USER_PASSWORD'
HOSTNAME='$HOSTNAME'
USERNAME='$USERNAME'
TIMEZONE='$TIMEZONE'
EOF

chmod 600 "$ROOT/root/install-vars"

# ------------------------------------------------------------
# Chroot installation script
# ------------------------------------------------------------

info "Creating chroot installer"

cat > "$ROOT/root/install-chroot.sh" <<'CHROOT'
#!/bin/bash
set -euo pipefail

source /root/install-vars

export HOME=/root
export PS1="(chroot) ${PS1:-# }"

# ------------------------------------------------------------
# Profile
# ------------------------------------------------------------

echo
echo ">>> Selecting systemd desktop profile"

eselect profile set default/linux/amd64/23.0/desktop/systemd

env-update
source /etc/profile

mkdir -p \
    /etc/portage/package.use \
    /etc/portage/package.accept_keywords \
    /etc/portage/package.license

# ------------------------------------------------------------
# Kernel / firmware / GRUB
# ------------------------------------------------------------

echo
echo ">>> Configuring kernel / firmware"

cat > /etc/portage/package.use/installkernel <<'EOF'
sys-kernel/installkernel systemd dracut grub
EOF

cat > /etc/portage/package.license/linux-firmware <<'EOF'
sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE
EOF

cat > /etc/portage/package.license/intel-microcode <<'EOF'
sys-firmware/intel-microcode intel-ucode
EOF

emerge --getbinpkg \
    sys-boot/grub \
    sys-kernel/dracut \
    sys-kernel/installkernel \
    sys-kernel/linux-firmware \
    sys-firmware/intel-microcode \
    sys-kernel/gentoo-kernel-bin

# ------------------------------------------------------------
# GRUB MBR / BIOS
# ------------------------------------------------------------

echo
echo ">>> Installing GRUB"

grub-install \
    --target=i386-pc \
    --recheck \
    /dev/sda

# ------------------------------------------------------------
# fstab
# ------------------------------------------------------------

echo
echo ">>> Creating fstab"

BOOT_UUID="$(blkid -s UUID -o value /dev/sda1)"
ROOT_UUID="$(blkid -s UUID -o value /dev/sda2)"

cat > /etc/fstab <<EOF
UUID=${BOOT_UUID}    /boot    ext4    noatime    1 2
UUID=${ROOT_UUID}    /        ext4    noatime    0 1
EOF

# ------------------------------------------------------------
# Timezone
# ------------------------------------------------------------

echo
echo ">>> Configuring timezone"

echo "$TIMEZONE" > /etc/timezone
emerge --config sys-libs/timezone-data

# ------------------------------------------------------------
# Locale
# ------------------------------------------------------------

echo
echo ">>> Configuring locale"

cat > /etc/locale.gen <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen
eselect locale set en_US.utf8

env-update
source /etc/profile

unset LC_ALL
unset LC_CTYPE

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ------------------------------------------------------------
# Portage
# ------------------------------------------------------------

echo
echo ">>> Syncing Gentoo repository"

emerge --sync

# ------------------------------------------------------------
# Hostname
# ------------------------------------------------------------

echo
echo ">>> Configuring hostname"

echo "$HOSTNAME" > /etc/hostname

# ------------------------------------------------------------
# Network
# ------------------------------------------------------------

echo
echo ">>> Installing NetworkManager / iwd"

emerge --getbinpkg \
    net-misc/networkmanager \
    net-wireless/iwd

systemctl enable NetworkManager
systemctl enable iwd
systemctl enable dbus

# ------------------------------------------------------------
# Sudo
# ------------------------------------------------------------

echo
echo ">>> Installing sudo"

emerge --getbinpkg app-admin/sudo

sed -i \
    's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' \
    /etc/sudoers

# ------------------------------------------------------------
# Sway USE flags
# ------------------------------------------------------------

echo
echo ">>> Configuring Sway USE flags"

cat > /etc/portage/package.use/sway <<'EOF'
gui-wm/sway X
gui-libs/wlroots X x11-backend
EOF

# ------------------------------------------------------------
# Sway / Wayland
# ------------------------------------------------------------

echo
echo ">>> Installing Sway / Wayland"

emerge --getbinpkg \
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

# ------------------------------------------------------------
# Mesa / PipeWire
# ------------------------------------------------------------

echo
echo ">>> Installing graphics / PipeWire"

emerge --getbinpkg \
    media-libs/mesa \
    media-libs/libglvnd

emerge --getbinpkg \
    media-video/pipewire \
    media-video/wireplumber \
    media-sound/alsa-utils

# ------------------------------------------------------------
# Desktop applications
# ------------------------------------------------------------

echo
echo ">>> Installing desktop applications"

emerge --getbinpkg \
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

# ------------------------------------------------------------
# GURU / Git
# ------------------------------------------------------------

echo
echo ">>> Installing Git / GURU"

emerge --getbinpkg \
    app-eselect/eselect-repository \
    dev-vcs/git

eselect repository enable guru
emaint sync -r guru

# ------------------------------------------------------------
# Fish
# ------------------------------------------------------------

echo
echo ">>> Installing Fish"

emerge --getbinpkg app-shells/fish

# ------------------------------------------------------------
# User
# ------------------------------------------------------------

echo
echo ">>> Creating user $USERNAME"

useradd \
    -m \
    -G wheel,audio,video,input,usb,plugdev \
    -s /bin/bash \
    "$USERNAME"

echo "root:${ROOT_PASSWORD}" | chpasswd
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

# Fish as user's shell
chsh -s /usr/bin/fish "$USERNAME"

# ------------------------------------------------------------
# IMPORTANT:
# Do NOT create Sway/Waybar configuration.
# User will provide their own configs.
# ------------------------------------------------------------

echo
echo ">>> Leaving user configuration untouched"

mkdir -p "/home/${USERNAME}/.config"

chown -R "${USERNAME}:users" "/home/${USERNAME}"

# ------------------------------------------------------------
# PipeWire
# ------------------------------------------------------------

echo
echo ">>> Enabling user services"

loginctl enable-linger "$USERNAME"

# ------------------------------------------------------------
# GRUB config
# ------------------------------------------------------------

echo
echo ">>> Generating GRUB configuration"

grub-mkconfig -o /boot/grub/grub.cfg

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

rm -f /root/install-vars
rm -f /root/install-chroot.sh

echo
echo "============================================================"
echo " Gentoo installation inside chroot completed"
echo "============================================================"

CHROOT

chmod +x "$ROOT/root/install-chroot.sh"

# ------------------------------------------------------------
# Enter chroot
# ------------------------------------------------------------

info "Entering Gentoo chroot"

chroot "$ROOT" /bin/bash /root/install-chroot.sh

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

info "Cleaning up"

rm -f "$ROOT/root/install-vars"
rm -f "$ROOT/root/install-chroot.sh"

sync

umount -R "$ROOT"

sync

# ------------------------------------------------------------
# Finished
# ------------------------------------------------------------

info "INSTALLATION COMPLETE"

echo
echo "Remove the installation media and reboot."
echo
read -rp "Press ENTER to reboot..."

reboot