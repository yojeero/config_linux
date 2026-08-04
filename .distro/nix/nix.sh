lsblk

sudo su

# ----------------------------------
# uefi gpt
# ----------------------------------
cfdisk /dev/sda

/dev/sda1 — 1 GiB, тип "EFI System"
/dev/sda2 — 50 GiB, тип "Linux filesystem"

mkfs.vfat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# ----------------------------------
# MBR msdos and one 50 GB partition
# ----------------------------------
fdisk /dev/sda 
o
n
p
1

2048
+50G
a
w

# Create an ext4 filesystem labeled nixos
mkfs.ext4 -L nixos /dev/sda1

mount /dev/disk/by-label/nixos /mnt

# ----------------------------------
# Generate hardware-configuration.nix directly into /mnt
# ----------------------------------
nixos-generate-config --root /mnt

# After this, two files - configuration.nix, hardware-configuration.nix
# hardware-configuration.nix -a snapshot of your hardware and mounted disks 

# Copy configuration.nix and flake.nix to the same folder /mnt/etc/nixos/

lsblk

# Mounting a multiboot flash drive
mkdir -p /mnt/usb
mount -o ro /dev/sdb1 /mnt/usb   # Mount in read-only mode for security

# Copy configuration.nix and flake.nix and merge the configuration into /mnt/etc/nixos/
# Copy your files to a temporary or target folder directly
cp /mnt/usb/Doc/Linux/HOME/.distro/nix/flake.nix /mnt/etc/nixos/
cp /mnt/usb/Doc/Linux/HOME/.distro/nix/configuration.nix /mnt/etc/nixos/

# Go to the files directory and run the installation, explicitly specifying the use of Flakes
cd /mnt/etc/nixos/

# install nixos
nixos-install --flake /mnt/etc/nixos/#laptop-lenovo

# If the installer asks you to enable experimental features, run the command with the flags
# nixos-install --flake .#laptop-lenovo --option experimental-features "nix-command flakes"

# Once the process is complete, set the root password (if the installer prompts)

passwd
sudo umount -R /mnt
reboot

