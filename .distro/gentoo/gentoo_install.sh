# === Run any LiveCD - openSuse ===

# MBR partitioning and formatting
lsblk
sudo cfdisk /dev/sda
sudo mkfs.ext4 /dev/sda1
sudo mkfs.ext4 /dev/sda2

# Mounting
sudo mkdir -p /mnt/gentoo
sudo mount /dev/sda2 /mnt/gentoo
sudo mkdir -p /mnt/gentoo/boot
sudo mount /dev/sda1 /mnt/gentoo/boot

cd /mnt/gentoo

# Download and extract Stage3 (desktop-systemd)
sudo wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20260510T170106Z/stage3-amd64-desktop-systemd-20260510T170106Z.tar.xz

# extract stage3
sudo tar xpvf stage3-amd64-desktop-systemd-20260510T170106Z.tar.xz --xattrs-include='*' --numeric-owner

# or download via browser or from USB
# copy to /mnt/gentoo
sudo cp /home/linux/stage3.tar.xz /mnt/gentoo
cd /mnt/gentoo
sudo tar xpvf stage3.tar.xz --xattrs-include='*' --numeric-owner

# Setting up make.conf (added support for binary packages)
sudo nano /mnt/gentoo/etc/portage/make.conf
# Paste
COMMON_FLAGS="-O2 -pipe"
FEATURES="getbinpkg"
EMERGE_DEFAULT_OPTS="--usepkg --binpkg-respect-use=y"
USE="-wayland"
VIDEO_CARDS="intel i915"

# Copy DNS
# echo "nameserver 8.8.8.8" | sudo tee /mnt/gentoo/etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /mnt/gentoo/etc/resolv.conf
cat /mnt/gentoo/etc/resolv.conf

# Mounting virtual systems (Important: BEFORE chroot!)
sudo mount --types proc /proc /mnt/gentoo/proc
sudo mount --rbind /sys /mnt/gentoo/sys
sudo mount --make-rslave /mnt/gentoo/sys
sudo mount --rbind /dev /mnt/gentoo/dev
sudo mount --make-rslave /mnt/gentoo/dev
sudo mount --bind /run /mnt/gentoo/run
sudo mount --make-slave /mnt/gentoo/run

# add this for systemd/grub:
sudo mount --bind /sys/fs/cgroup /mnt/gentoo/sys/fs/cgroup

# ENTER CHROOT
sudo chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

# === INSIDE CHROOT (without sudo) ===

# Key initialization and synchronization
emerge --sync
getuto

# Profile selection (Look for desktop/systemd/merged-usr)
eselect profile list
eselect profile set 4 # Replace with your desktop/systemd profile number

# Setting up locales
echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

nano /etc/locale.gen
# Uncomment en_US.UTF-8 and ru_RU.UTF-8
locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# Updating the World (using binary packages)
emerge -avuDN @world

# Installing the Kernel and firmware
emerge sys-kernel/linux-firmware sys-kernel/gentoo-kernel-bin

# Setting up fstab
nano /etc/fstab

/dev/sda1  /boot  ext4  defaults  0 2
/dev/sda2  /      ext4  noatime   0 1

echo "gentoo-z570" > /etc/hostname

# pkgs installation
emerge net-misc/networkmanager app-admin/sudo sys-apps/dbus x11-base/xorg-server emerge x11-wm/bspwm x11-misc/sxhkd x11-terms/alacritty x11-misc/rofi x11-misc/polybar media-gfx/feh x11-misc/picom app-shells/fish www-client/firefox-bin x11-apps/xinit emerge media-video/pipewire media-sound/pipewire-alsa media-sound/wireplumber

# Enabling services via the --root flag
systemctl enable NetworkManager
systemctl enable dbus

# Setting up GRUB
echo "sys-boot/grub mount" >> /etc/portage/package.use/grub
emerge --ask sys-boot/grub sys-boot/os-prober
grub-install --target=i386-pc /dev/sda

# for UEFI
# grub-install --target=x86_64-efi --efi-directory=/boot

grub-mkconfig -o /boot/grub/grub.cfg   

# Setting up users
passwd
useradd -m -G wheel,video,audio,input -s /bin/bash USER
passwd USER

EDITOR=nano visudo 
# Uncomment %wheel

# User setup (bspwm)
su - USER
mkdir -p ~/.config/bspwm ~/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
chmod +x ~/.config/bspwm/bspwmrc
echo "exec bspwm" > ~/.xinitrc

nano ~/.bash_profile
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx -- -keeptty > ~/.xsession-errors 2>&1
fi

nano /home/USER/.xinitrc
#!/bin/sh
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

export XDG_CURRENT_DESKTOP=bspwm
export XDG_SESSION_DESKTOP=bspwm
export XDG_SESSION_TYPE=x11

chmod +x /home/USER/.xinitrc

# Запуск bspwm через dbus для работы PipeWire и флешек
exec dbus-run-session bspwm

exit # Exit user back to root chroot
exit # Exit chroot to the host system

# === AGAIN ON THE LiveCD SYSTEM ===
sudo umount -l /mnt/gentoo/dev{/shm,/pts,}
sudo umount -R /mnt/gentoo
sudo reboot

