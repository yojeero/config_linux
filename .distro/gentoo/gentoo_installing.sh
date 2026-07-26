minimum installation:

1. Unpack stage3.
2. Set up `make.conf`.
3. `emerge --sync` (or `emerge-webrsync` if the PGP problem arises again).
4. Select a profile.
5. Install:

   *`grub`
   *`installkernel`
   *`dracut`
   *`linux-firmware`
   *`intel-microcode`
   *`gentoo-kernel-bin`

6. Check that `/boot` contains:

   *`vmlinuz-*`
   *`initramfs-*`

7. Install GRUB and generate `grub.cfg`.
8. Configure `fstab`.
9. Create a user.
10. Reboot and make sure that the system boots into the console.
11. Only after this install Xorg, Spectrwm, Firefox and the rest.

This approach is easier to debug: if something goes wrong, you know that the problem is in the underlying system, and not in the graphics or display manager.

### If the screen is black again

*press `e` in GRUB;
*add parameters to the `linux` line:

  ```
  nomodeset loglevel=7 ignore_loglevel
  ```
  
*boot the system.

Very often this immediately shows at what stage the problem arises.