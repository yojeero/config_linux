In general, if you have some decent live environment, you can set up the drives using a tool like parted, format the drives, and extract stage3 + Portage to the root filesystem. Assuming you are simply installing Gentoo on a modern PC, you will need the following sections:

EFI (~100 MiB is enough, format as vfat and make sure the boot and esp flags are set).

/boot (~1 GiB is more than enough, formatting as ext2 is optional).

/ (remaining disk space, format as ext4 or btrfs, if btrfs you may need a separate /boot, but GRUB also supports btrfs).

/home (remaining disk space, format the same as /, optional).

swap (same size as the amount of DRAM you have, mostly useful when you want to suspend work to disk).

Mounting partitions:

Mount /as /mnt

Mount /home as /mnt/home

Mount /boot as /mnt/boot

Mount EFI as /mnt/boot/efi

Then chroot to /mnt (see also: https://wiki.gentoo.org/wiki/Chroot)

Your next goal should be to get something that loads:

Set a root password or create your own user and set a password + put the user in the wheel group.

Configure /etc/fstab to mount your partitions. Use blkid to get the UUID so you can just point the UUID in your /etc/fstab.

Build a kernel (I highly recommend looking at genkernel for this).

Install GRUB 2 (or whatever bootloader you prefer).

Generate the GRUB 2 configuration file at /boot/grub/grub.cfg.

Set up your network. For wired networks, you can simply emerge dhcpcd and run rc-update add dhcpcd default. Alternatively, you can emerge wpa_supplicant and run rc-update add wpa_supplicant default for wireless networks (remember to configure your SSID + credentials in /etc/wpa_supplicant/wpa_supplicant.conf).

You can install some basic tools like vim (I can't use nano, sorry) and eix.

There's a bit more on the wiki and installation guide, but I really try to keep it minimal (UTF-8, timezone, hostname, etc.).

If it downloads and you can access your network, then you can proceed with the Gentoo installation. If not, then you will have to go back to your live environment and use chroot to fix it. Alternatively, if you want to use the live environment during this time (for example, watch movies while Gentoo cycles through packages), you can simply continue with the installation using chroot.

The next step from here is to configure the video drivers (eg AMDGPU) and input devices (synaptics, evdev and libinput) in your /etc/portage/make.conf. I also recommend starting by setting some global USE flags such as X, dbus, elogind and policykit. Then install xorg-server and some WM (for example i3-gaps) and lightdm. Alternatively, you may be more interested in running a desktop environment, in which case you'll need to look at how to install GNOME or KDE or whatever you like. Once you get to the point where you can use X and have a basic terminal installed (I use Terminology, but kitty and rxvt-unicode are also decent options) and can use a web browser like Firefox, it's mostly a matter of handling various tasks like audio (ALSA or PulseAudio), networking (maybe you need NetworkManager or wicd), Bluetooth (blueman), etc., and installing the apps you need (you may be using Inkscape, Krita, Thunderbird, Blender, Steam, etc.).