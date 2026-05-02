

BIOS Legacy + MBR

# MBR
fdisk /dev/sda

/dev/sda1   512M   /boot
/dev/sda2   50G  /   Linux (root)

# /dev/sda1 bootable

# format
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

# mount
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

mkdir -p /mnt
mount /dev/sda2 /mnt

---------------------------------------

BIOS Legacy + GPT

# MBR
fdisk /dev/sda

/dev/sda1   1M   bios_boot
/dev/sda2   2G   /boot
/dev/sda3   50G  /   Linux (root)

# /dev/sda1 bootable

# format
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3

# mount
mkdir -p /mnt/boot
mount /dev/sda2 /mnt/boot

mkdir -p /mnt
mount /dev/sda3 /mnt

---------------------------------------

UEFI + GPT 

# GPT
fdisk /dev/sda

/dev/sda1   1G   /boot     Linux (boot, флаг boot)
/dev/sda2   50G  /         Linux (root)

# /dev/sda1
# EFI System (ef00)

# format
mkfs.fat -F 32 /dev/sda1
fatlabel /dev/sda1 EFI
mkfs.ext4 /dev/sda2

# mount
mkdir -p /mnt
mount /dev/sda2 /mnt

mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

----------------------------------------------
