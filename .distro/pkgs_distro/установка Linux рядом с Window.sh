
# ----------------------------------
# установка Linux рядом с Windows
# ----------------------------------

Сперва ставишь на один диск винду, на второй линукс с grub2 (надеюсь, тут вопросов не будет). После загружаешься на Линукс, топаешь в /etc/default/grub, ищешь строку GRUB_DISABLE_OS_PROBER=false, раскомментируешь. Далее устанавливаешь os-prober, далее даëшь команду grub-mkconfig -o /boot/grub/grub.cfg. По идее, если всё по дефолту, то при перезагрузке должна появится возможность выбирать винду или линь.

https://losst.pro/ustanovka-linux-ryadom-s-windows-10


fdisk -l

/dev/sda1 29 8369 66999082+ 83 Linux
/dev/sda2 * 8370 13995 45190845 7 HPFS/NTFS
/dev/sda3 13996 14593 4803435 5 Extended

Видим, что наша Linux стоит в разделе / dev / sda1

# обращайте внимание на каком разделе у вас стоит Linux, его и подставляете вместо sda1

mount /dev/sda1 /mnt
mount --bind /dev /mnt/dev
mount --bind /dev/pts /mnt/dev/pts
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
chroot /mnt
grub-install /dev/sda
update-grub
exit
umount /mnt/dev/pts
umount /mnt/dev
umount /mnt/proc
umount /mnt/sys
umount /mnt

# reboot и наблюдаем знакомое меню выбора ОС. 
# если вдруг пункт Windows в нем отсутствует, выполняем в консоли под root

os-prober
update-grub