
# Windows + Lmde dualboot

# in lmde
sudo su -
parted /dev/sda
set 1 boot off

# gparted
# create new efi partition
512mb

# select new efi partition for installation
# mount point /boot/efi

# after installation Lmde go to terminal

parted /dev/sda
p
set 1 boot on

# exit and reboot

# enter Lmde, terminal

sudo su -
nano /etc/default/grub

# insert on down stroke
GRUB_DISABLE_OS_PROBER=false

# save and exit

os-prober
grub-mkconfig -o /boot/grub/grub.cfg
df -h

reboot
------------------------------
# Create a new partition table (GPT for UEFI, MBR for BIOS systems).

# list disk
lsblk -f

------------------------------

# debian
sda                                                                            
├─sda1 	vfat   	esp       1GiB    	 /boot
├─sda2 	ext4   	root	 20GiB   	 /
└─sda3 	                  2GiB  	  SWAP

-----------------------------

# fedora                                                      
sda                                                                            
├─sda1 	vfat   	FAT32    650MiB    	 /boot/efi
├─sda2 	ext4   			   1GiB   	 /boot
└─sda3 	btrfs     			22G  	 /

zram0                [SWAP]


3: create a btrfs volume
3a: create a subvolume label=@ 			 mount=/
3b: create a subvolume label=@home 			 mount=/home

--------------------------------

## Create partitions
EFI Partition: Select free space → New Partition → 512MB → Format as FAT32 → Mount at /boot/efi.
Root Partition (/): Select free space → New Partition → Assign required size (20GB+) → Format as ext4 → Mount at /.
Home Partition (/home): Select free space → Assign large portion → Format as ext4 → Mount at /home.
Swap Partition: Select free space → Assign recommended size → Set as “swap area”.
Boot Partition (/boot) (if needed): Create a separate partition of 1GB → Format as ext4 → Mount at /boot.

## Installing the Bootloader
If using UEFI, the bootloader (GRUB) should automatically install on the EFI partition.
If using BIOS, install GRUB on the main disk (/dev/sda or /dev/nvme0n1).
