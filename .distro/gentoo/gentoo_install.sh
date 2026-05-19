# ----------------------------------
# Gentoo Installing via any LiveCD 
# @yojeero
# ----------------------------------

# reset MBR
sudo dd if=/dev/zero of=/dev/sda bs=512 count=1 conv=notrunc

# MBR partitioning and formatting
lsblk
sudo cfdisk /dev/sda
sudo mkfs.ext4 /dev/sda1
sudo mkfs.ext4 /dev/sda2

# Mounting ROOT first
sudo mkdir -p /mnt/gentoo
sudo mount /dev/sda2 /mnt/gentoo
cd /mnt/gentoo

# ======= web stage ========

# download and extract Stage3 (desktop-systemd)
sudo wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20260510T170106Z/stage3-amd64-desktop-systemd-20260510T170106Z.tar.xz

# extract stage3
sudo tar xpvf stage3-amd64-desktop-systemd-20260510T170106Z.tar.xz --xattrs-include='*' --numeric-owner

# ======= end web stage ========

# OR use

# ======= local stage ========

# copy to /mnt/gentoo from USB

# Copy and extract Stage3 (DO THIS BEFORE MOUNTING BOOT!)
sudo cp /home/linux/stage3.tar.xz /mnt/gentoo
sudo tar xpvf stage3.tar.xz --xattrs-include='*' --numeric-owner

# ======= end local stage ========

# NOW mount BOOT partition over the extracted structure
sudo mount /dev/sda1 /mnt/gentoo/boot

# make.conf configuration
sudo nano /mnt/gentoo/etc/portage/make.conf
# Paste:
COMMON_FLAGS="-O2 -pipe"
FEATURES="getbinpkg"
EMERGE_DEFAULT_OPTS="--usepkg --binpkg-respect-use=y"
USE="-wayland"
VIDEO_CARDS="intel"

# DNS
echo "nameserver 1.1.1.1" | sudo tee /mnt/gentoo/etc/resolv.conf

# Mounting virtual filesystems
sudo mount --types proc /proc /mnt/gentoo/proc
sudo mount --rbind /sys /mnt/gentoo/sys
sudo mount --make-rslave /mnt/gentoo/sys
sudo mount --rbind /dev /mnt/gentoo/dev
sudo mount --make-rslave /mnt/gentoo/dev
sudo mount --bind /run /mnt/gentoo/run
sudo mount --make-slave /mnt/gentoo/run
sudo mount --bind /sys/fs/cgroup /mnt/gentoo/sys/fs/cgroup
sudo mount --types tmpfs shm /mnt/gentoo/dev/shm

# Enter CHROOT
sudo chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

# ==============================
# INSIDE CHROOT
# ==============================

# Sync and Portage keys
emerge --sync
getuto

# Set Profile (Ensure it is merged-usr!)
# When selecting a profile (eselect profile list): Look for the line where it says desktop/systemd/merged-usr (or desktop/systemd/plasma/merged-usr, if you want KDE). The merged-usr flag is now critical for the correct operation of the binary kernel and dracut.

eselect profile list
eselect profile set 4 

# Timezone and Locales
echo "Europe/Moscow" > /etc/timezone
emerge --config sys-libs/timezone-data

nano /etc/locale.gen
# Uncomment: en_US.UTF-8 UTF-8 and ru_RU.UTF-8 UTF-8

locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# Update World
emerge -avuDN @world

# Kernel setup
echo "sys-kernel/installkernel dracut grub" >> /etc/portage/package.use/installkernel
mkdir -p /etc/kernel
echo "layout=grub" > /etc/kernel/install.conf

emerge sys-kernel/linux-firmware sys-kernel/gentoo-kernel-bin

# FSTAB configuration
nano /etc/fstab
# Paste:
/dev/sda1   /boot        ext4    noatime              1 2
/dev/sda2   /            ext4    noatime              0 1

echo "gentoo-z570" > /etc/hostname

# Install Base Software and Desktop Environment
emerge net-misc/networkmanager \
       app-admin/sudo \
       x11-base/xorg-server \
       x11-base/xorg-drivers \
       x11-wm/bspwm \
       x11-misc/sxhkd \
       x11-terms/alacritty \
       x11-misc/rofi \
       x11-misc/polybar \
       x11-misc/picom \
       media-gfx/feh \
       www-client/firefox-bin \
       media-video/pipewire \
       media-sound/wireplumber \
       x11-apps/xinit \
       x11-apps/xauth \
       sys-auth/seatd \
       gui-apps/greetd \
       gui-libs/tuigreet \
       app-shells/bash-completion \
       sys-process/htop \
       app-editors/neovim \
       x11-misc/xdg-utils

# System Services
systemctl enable NetworkManager
systemctl enable greetd
systemctl enable seatd

# GRUB Installation (Guaranteed to find kernel now)
echo "sys-boot/grub mount" >> /etc/portage/package.use/grub
emerge --ask sys-boot/grub sys-boot/os-prober
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg   

# User Creation & Permissions
passwd
useradd -m -G wheel,video,audio,input -s /bin/bash USER
passwd USER
gpasswd -a USER seat

# Fix greetd permissions for X11/tuigreet
gpasswd -a greeter video
gpasswd -a greeter seat

# Sudo Configuration
EDITOR=nano visudo 
# Uncomment 
%wheel ALL=(ALL:ALL) ALL

# BSPWM & SXHKD Configs for User
mkdir -p /home/USER/.config/bspwm /home/USER/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc /home/USER/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc /home/USER/.config/sxhkd/
chmod +x /home/USER/.config/bspwm/bspwmrc

# Greetd Configuration
mkdir -p /etc/greetd
nano /etc/greetd/config.toml
# Paste:
[terminal]
vt = 1
[default_session]
command = "tuigreet --cmd startx"
user = "greeter"

# Create .xinitrc for User securely
nano /home/USER/.xinitrc
# Paste:
#!/bin/sh
export XDG_CURRENT_DESKTOP=bspwm
export XDG_SESSION_DESKTOP=bspwm
export XDG_SESSION_TYPE=x11
exec dbus-run-session bspwm

chmod +x /home/USER/.xinitrc
chown -R USER:USER /home/USER/

# Exit Chroot
exit 

# Unmounting and Reboot
sudo umount -l /mnt/gentoo/dev/shm
sudo umount -l /mnt/gentoo/proc
sudo umount -R /mnt/gentoo
sudo reboot

# ==========================================
# AFTER FIRST BOOT (Run as USER)
# ==========================================
systemctl --user enable pipewire pipewire-pulse wireplumber
