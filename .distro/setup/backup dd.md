
sudo apt-get clean           							# Очистка кэша пакетного менеджера
sudo apt-get autoremove      				# Удаление ненужных пакетов
sudo rm -rf /tmp/*           							# Очистка временных файлов

sudo apt-get update && sudo apt-get upgrade -y

------------------------------------------------------------------

# list your disks

sudo fdisk -l

# dd backup ------------------------------------------

# create a partition image of whole disk

sudo dd if=/dev/sda of=/dev/sdb bs=64K conv=noerror,sync status=progress


# sometimes you can see different names of disk, eg. nvme for SSD M.2

sudo dd if=/dev/sda conv=sync,noerror bs=128K status=progress | gzip -c > /media/disk2/images/SSD_image.gz

# dd restore -----------------------------------------------------------------

# restore compressed image to a new disk

sudo gunzip -c SSD_image.gz | dd of=/dev/sda status=progress

-----------------------------------------------

# восстановление загрузочного сектора (если требуется)

#  после восстановления может потребоваться восстановить загрузчик с помощью утилиты grub-install

sudo mount /dev/sda1 /mnt
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
grub-install /dev/sda
update-grub
exit