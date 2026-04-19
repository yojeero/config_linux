Artix + dinit + sway

# watch the disc
lsblk

# disk partitioning
cfdisk /dev/sda

# Разметка MBR BIOS
/dev/sda1 → ext4 → /

# без swap-раздела — swapfile

# Formatting
mkfs.ext4 /dev/sda1

# enable boot flag in cfdisk
# 50gb partition

# base system
mount /dev/sda1 /mnt
basestrap /mnt base base-devel linux linux-firmware dinit elogind-dinit dbus-dinit mkinitcpio sudo nano 

# fstab
mkdir -p /mnt/etc
fstabgen -U /mnt >> /mnt/etc/fstab

# chroot
artix-chroot /mnt

# initramfs
mkinitcpio -P

# system config minimum
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
nano /etc/locale.gen
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
locale-gen

# hostname
nano /etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 artix.localdomain artix

# users
passwd
useradd -m -G wheel,audio,video,input yopy
passwd yopy
EDITOR=nano visudo
%wheel ALL=(ALL) ALL

# bootloader BIOS MBR
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# network minimum
pacman -S networkmanager networkmanager-dinit
ln -s /etc/dinit.d/NetworkManager /etc/dinit.d/boot.d/

# dbus
pacman -S dbus-dinit
ln -s /etc/dinit.d/dbus /etc/dinit.d/boot.d/

# graphics ONLY sway core
pacman -S sway foot wl-clipboard xdg-desktop-portal-wlr

# login greetd minimal
pacman -S greetd greetd-tuigreet
useradd -M -s /usr/bin/nologin greeter
nano /etc/greetd/config.toml

[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd 'dbus-run-session sway'"
user = "greeter"

# audio minimal PipeWire
pacman -S pipewire wireplumber pipewire-pulse

# polkit minimum
pacman -S polkit polkit-gnome

# GPU safe minimal
pacman -S mesa libva-intel-driver

# sway config ultra-clean
mkdir -p ~/.config/sway
nano ~/.config/sway/config
exec dbus-update-activation-environment --all WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
exec nm-applet

# finish
exit
umount -R /mnt
reboot