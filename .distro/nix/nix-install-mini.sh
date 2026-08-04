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

# Generate a hardware config (will create hardware-configuration.nix)
nixos-generate-config --root /mnt

# Copy your files from the flash drive
cp /mnt/usb/Doc/Linux/HOME/.distro/nix/flake.nix /mnt/etc/nixos/
cp /mnt/usb/Doc/Linux/HOME/.distro/nix/configuration.nix /mnt/etc/nixos/

# Go to the working folder
cd /mnt/etc/nixos/

# Turn the folder into a local Git repository
git init
git config --global user.email "installer@nixos.org"
git config --global user.name "NixOS Installer"

# Add ALL files to the Git index (THIS IS THE MOST IMPORTANT STEP)

# This will add flake.nix, configuration.nix and the generated hardware-configuration.nix
git add -A

# Create/update a lock file to fix the correct repository hashes
nix --extra-experimental-features "nix-command flakes" flake update

# If you updated the lock file, it ALSO needs to be added to Git before installation
git add flake.lock

# Start the installation
nixos-install --flake .#laptop-lenovo --option experimental-features "nix-command flakes"

# Once the process is complete, set the root password (if the installer prompts)

passwd
sudo umount -R /mnt
reboot

