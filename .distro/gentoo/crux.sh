Installing CRUX 3.8.0 (MBR / BIOS Edition)

lsblk

# erase disk
sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# Create MBR table in cfdisk:
# /dev/sda1 -1GB, type Linux, make BOOTABLE (Bootable /flag *)
# /dev/sda2 -50GB, Linux type
cfdisk /dev/sda

# format 
mkfs.ext4 /dev/sda1
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

/dev/sda1   /boot   ext4    noatime     1 2
/dev/sda2   /       ext4    noatime     0 1

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
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# reboot
exit 
umount -R /mnt 
reboot 

# After reboot: user creation
useradd -m -g users -G wheel,audio,video -s /bin/bash USER
passwd USER

cd /etc/ports
# Activate the base system, additional packages and community ports
ln -s /etc/ports/core.rsync .
ln -s /etc/ports/opt.rsync .
ln -s /etc/ports/contrib.rsync .

ports -u

ports -v

# There is no single command in CRUX like apt upgrade. The update occurs by compiling the source code. To update outdated packages, run:

ports -u

# Use the code with caution. (Yes, the command is the same. Run a second time, it will begin building and installing updates sequentially).

# If you want to update a specific package manually without touching the others:

cd /usr/ports/core/package_name # or /opt/, /contrib/
pkgmk -d -i

# The -d (download) flag will automatically download the program's source code.
# The -i (install) flag will install the compiled binary on the system.

# Найти пакет по имени:
ports -l | grep имя_программы

# Find out which package owns a file on the system
pkginfo -o /usr/bin/wget

# View a list of all installed programs
pkginfo -i

# ----------------------------------
# spectrwm
# ----------------------------------
prt-get depinst xorg

git clone https://github.com/Y-Forks/spectrwm
cd spectrwm/linux
make
make install

prt-get depinst alacritty rofi picom feh maim slop xclip dunst wireplumber








