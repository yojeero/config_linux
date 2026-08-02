# Gentoo systemd (Binary / MBR / TTY / StartX / Spectrwm)

## 1. Erase disks

``` sh
lsblk
sudo su

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
```

## 2. Stage3

``` sh
mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

mkdir -p /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

cd /mnt/gentoo
tar xpvf /media/live/Verbatim/TUX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner

date 072915272026
```

## 3. make.conf

`nano /mnt/gentoo/etc/portage/make.conf`

``` conf
COMMON_FLAGS="-O2 -pipe -march=sandybridge"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"

FEATURES="${FEATURES} getbinpkg parallel-fetch"
EMERGE_DEFAULT_OPTS="--ask --verbose --with-bdeps=y"

MAKEOPTS="-j8"

VIDEO_CARDS="intel"
INPUT_DEVICES="libinput"

USE="X systemd udev dbus alsa pulseaudio vaapi"

GENTOO_MIRRORS="https://distfiles.gentoo.org"
```

## 4. Repo

``` sh
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
```

## 5. DNS

``` sh
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

cat >/mnt/gentoo/etc/resolv.conf <<EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF
```

## 6. Chroot

``` sh
mount -t proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```

## 7. Portage

``` sh
emerge --sync

eselect profile list | less
eselect profile set default/linux/amd64/23.0/desktop/systemd

env-update
source /etc/profile

mkdir -p \
/etc/portage/package.use \
/etc/portage/package.accept_keywords \
/etc/portage/package.license
```

# chroot
export PS1="(chroot) $PS1"

## 8. Kernel

``` sh
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

grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```
## 9. Fstab

``` sh
blkid

nano /etc/fstab

UUID="7f787592-31eb-4092-b01d-ba49e9a43eb1"     /boot   ext4    noatime     1 2
UUID="f39e4e5b-3b6f-453e-9168-46fa9e6f3901"     /       ext4    noatime     0 1

```

/dev/sda1   /boot   ext4    noatime     1 2
/dev/sda2   /       ext4    noatime     0 1

## 10. Local

``` sh
echo Europe/Moscow >/etc/timezone
emerge --config sys-libs/timezone-data

cat >/etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen
eselect locale set en_US.utf8
env-update
source /etc/profile
```

## 11. Network

``` sh
echo gentoo >/etc/hostname

emerge --ask net-misc/networkmanager net-wireless/iwd net-misc/dhcpcd

systemctl enable NetworkManager
systemctl enable iwd
systemctl enable dbus
```

## 12. X11

``` sh
emerge --ask \
x11-base/xorg-server \
x11-base/xinit \
media-libs/mesa \
x11-drivers/xf86-input-libinput \
sys-apps/dbus \
app-admin/sudo

visudo
```

%wheel ALL=(ALL:ALL) ALL

## 13. Keyboard

``` sh
mkdir -p /etc/X11/xorg.conf.d

cat >/etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "us,ru"
    Option "XkbOptions" "grp:alt_shift_toggle"
EndSection
EOF
```
# keyboard swith

``` sh
git clone https://github.com/Y-Forks/xkb-switch
cd xkb-switch
mkdir build && cd build
cmake ..
make
sudo make install
sudo ldconfig
```

## 14. GURU

``` sh
emerge --ask app-eselect/eselect-repository dev-vcs/git
eselect repository enable guru
emaint sync -r guru
```

## 15. Spectrwm v.3.7.0

``` sh
git clone https://github.com/Y-Forks/spectrwm
cd spectrwm/linux
make
make install
```

## 16. Pkgs

``` sh
emerge --ask \
x11-terms/alacritty \
x11-misc/rofi \
x11-misc/picom \
media-gfx/feh \
app-editors/xed \
app-misc/fastfetch \
x11-misc/dunst \
x11-misc/xclip \
media-gfx/maim \
x11-misc/slop \
x11-apps/xsetroot \
www-client/firefox \
gnome-extra/nemo \
gnome-extra/nemo-fileroller \
app-arch/file-roller \
gnome-base/gvfs \
sys-fs/udisks \
x11-libs/gdk-pixbuf \
app-editors/micro \
app-editors/vim \
app-misc/mc \
sys-process/bottom \
media-video/celluloid \
media-gfx/imagemagick \
media-video/ffmpeg \
media-video/ffmpegthumbnailer \
media-gfx/imv \
x11-base/xorg-apps \
x11-misc/lxappearance \
media-fonts/noto
```

## 17. i3lock-color

``` sh
echo "x11-misc/i3lock-color ~amd64" \
>/etc/portage/package.accept_keywords/i3lock-color

emerge --ask x11-misc/i3lock-color
```

## 18. User

``` sh
passwd

useradd -m -G wheel,audio,video,input,,usb,plugdev -s /bin/bash yopy

passwd yopy
```

# 19. set SHELL FISH

emerge --ask app-shells/fish sys-apps/eza app-shells/fzf sys-apps/fd

chsh -s /usr/bin/fish yopy

## 20. .xinitrc

``` sh
cat >/home/yopy/.xinitrc <<'EOF'
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

gentoo-pipewire-launcher &

systemctl --user import-environment DISPLAY XAUTHORITY

exec spectrwm
EOF

chown yopy:users /home/yopy/.xinitrc
```

## 21. Unmount

``` sh
exit
umount -lR /mnt/gentoo
reboot
```

# After reboot

``` sh
startx
```
