
# rebuild GRUB 

sudo cfdisk /dev/sda

/dev/sda1 * boot

# mounting
sudo mkdir -p /mnt/gentoo
sudo mount /dev/sda2 /mnt/gentoo
sudo mkdir -p /mnt/gentoo/boot
sudo mount /dev/sda1 /mnt/gentoo/boot

# Mounting virtual systems (Important: BEFORE chroot!)
sudo mount --types proc /proc /mnt/gentoo/proc
sudo mount --rbind /sys /mnt/gentoo/sys
sudo mount --make-rslave /mnt/gentoo/sys
sudo mount --rbind /dev /mnt/gentoo/dev
sudo mount --make-rslave /mnt/gentoo/dev
sudo mount --bind /run /mnt/gentoo/run
sudo mount --make-slave /mnt/gentoo/run
sudo mount --bind /sys/fs/cgroup /mnt/gentoo/sys/fs/cgroup
sudo mount --types tmpfs shm /mnt/gentoo/dev/shm

# CHROOT
sudo chroot /mnt/gentoo /bin/bash
source /etc/profile

# Reinstall the MBR boot record
grub-install --target=i386-pc /dev/sda

# Generate the configuration file
grub-mkconfig -o /boot/grub/grub.cfg

# Exit chroot back to LiveCD
exit

# unmount
sudo umount -l /mnt/gentoo/dev/shm
sudo umount -l /mnt/gentoo/dev/pts
sudo umount -l /mnt/gentoo/dev
sudo umount -l /mnt/gentoo/proc
sudo umount -l /mnt/gentoo/sys/fs/cgroup
sudo umount -l /mnt/gentoo/sys
sudo umount -l /mnt/gentoo/run

sudo umount /mnt/gentoo/boot
sudo umount /mnt/gentoo

sudo reboot
