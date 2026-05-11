# MBR
lsblk

cfdisk /dev/sda

50G	ext4 Linux root boot   / 

# format
mkfs.ext4 /dev/sda1

# mount
mkdir -p /mnt
mount /dev/sda1 /mnt

# disk info
sudo fdisk -l /dev/sda