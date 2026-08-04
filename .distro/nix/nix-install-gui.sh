installing via calamares

after reboot

sudo su

mkdir -p /mnt/usb
mount -o ro /dev/sdb1 /mnt/usb

cp /mnt/usb/Doc/Linux/HOME/.distro/nix/flake.nix /etc/nixos/
cp /mnt/usb/Doc/Linux/HOME/.distro/nix/configuration.nix /etc/nixos/

cd /etc/nixos/

git init
git config --global user.email "installer@nixos.org"
git config --global user.name "NixOS Installer"

git add -A

nix --extra-experimental-features "nix-command flakes" flake update

git add flake.lock

nixos-rebuild switch --flake .#laptop-lenovo --option experimental-features "nix-command flakes"
