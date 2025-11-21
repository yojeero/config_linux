
# =================================
# Windows + Lmde dualboot
# ==================================

# in lmde
sudo su -
parted /dev/sda
p
set 1 boot off

gparted
# create new efi partition
512mb

# select new efi partition for installation
mount point /boot/efi

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
