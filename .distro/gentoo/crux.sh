
# ----------------------------------
# Installing CRUX 3.8.0 (MBR / BIOS Edition)
# login - root
# ----------------------------------

lsblk

# erase disk
sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# Create MBR table in cfdisk:
# /dev/sda1 -1GB, type Linux, make BOOTABLE (Bootable /flag *) FAT32
# /dev/sda2 -50GB, Linux type  ext4
cfdisk /dev/sda

# format 
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# mount
mount /dev/sda2 /mnt

mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Run the installer (select core, opt, and grub2 from opt)
setup

# Login to chroot (CRUX uses setup-chroot script)
setup-chroot

passwd

# fstab
nano /etc/fstab

/dev/sda1   /boot   vfat    noatime   0 2
/dev/sda2   /       ext4    noatime   0 1

# local
localedef -i en_US -f UTF-8 en_US.UTF-8 
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8 

# host
nano /etc/hostname

# any you want
crux

nano /etc/hosts

127.0.0.1    localhost
::1          localhost
127.0.1.1    crux.localdomain     crux

# kernel
ls /usr/src/
cd /usr/src/linux-6.12.55

# Create a basic config instead of oldconfig (CRITICAL!)
make defconfig
# (Optional) Change the settings for yourself:
# make menuconfig 

# Compilation (the -j$(nproc) flag will speed up the compilation significantly)
make -j$(nproc)
make modules_install
cp arch/x86/boot/bzImage /boot/vmlinuz
cp System.map /boot

# Установка GRUB на MBR
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Проверка
ls -lh /boot/vmlinuz
ls -lh /boot/grub/grub.cfg

grub-probe /
grub-probe /boot

# reboot
exit 
umount -R /mnt 
reboot 

# After reboot: user creation
useradd -m -g users -G wheel,audio,video -s /bin/bash USER
passwd USER

cd /etc/ports
ls -l

ports -u
ports -v
ports -u

prt-get update
prt-get install package_name

# for update
prt-get update package_name

# find pkg
prt-get search nano

# View a list of all installed programs
pkginfo -i

# ----------------------------------
# i3
# ----------------------------------
prt-get depinst \
    xorg \
    i3 \
    i3lock \
    i3status-rust \
    bemenu \
    alacritty \
    feh \
    maim \
    slop \
    xclip \
    dunst 

prt-get depinst \
    firefox \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    mousepad \
    engrampa \
    tumbler 

prt-get depinst \
    mc \
    fastfetch \
    btop 

prt-get depinst \
    wget \
    git \
    curl \
    gvfs \
    udisks2 \
    ntfs-3g 

prt-get depinst \
    xdg-utils \
    ripgrep \
    zoxide \
    imagemagick \
    ffmpeg \
    p7zip \
    unzip \
    zip \
    tar

# ----------------------------------
# SHELL FISH
# ----------------------------------
prt-get depinst \
    fish eza fzf fd

chsh -s $(command -v fish)

