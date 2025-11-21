
# Create a new partition table (GPT for UEFI, MBR for BIOS systems).

# list disk
lsblk -f

----------------

## Create partitions
EFI Partition: Select free space → New Partition → 512MB → Format as FAT32 → Mount at /boot/efi.

Root Partition (/): Select free space → New Partition → Assign required size (20GB+) → Format as ext4 → Mount at /.

Home Partition (/home): Select free space → Assign large portion → Format as ext4 → Mount at /home.

Swap Partition: Select free space → Assign recommended size → Set as “swap area”.

Boot Partition (/boot) (if needed): Create a separate partition of 1GB → Format as ext4 → Mount at /boot.

## Installing the Bootloader
If using UEFI, the bootloader (GRUB) should automatically install on the EFI partition.

If using BIOS, install GRUB on the main disk (/dev/sda or /dev/nvme0n1).
