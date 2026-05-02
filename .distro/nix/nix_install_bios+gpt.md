# installing NixOS + Home Manager + bspwm in BIOS Legacy + GPT

# GPT
/dev/sda1  1M      BIOS boot partition   (type EF02)
/dev/sda2  512M    /boot (ext4)
/dev/sda3  rest    / (ext4)

# partittion
gdisk /dev/sda

o → новая GPT
n → раздел 1 → +1M → тип EF02
n → раздел 2 → +512M → тип 8300
n → раздел 3 → остальное → тип 8300
w → записать

# format
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3

# mount
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda2 /mnt/boot

# install NixOS
nixos-generate-config --root /mnt

nano /mnt/etc/nixos/configuration.nix

boot.loader.grub.enable = true;
boot.loader.grub.device = "/dev/sda";  
boot.loader.grub.useOSProber = false;

boot.loader.grub.efiSupport = false;  

nixos-install

# configuration.nix
{ config, pkgs, ... }:

{
imports =
[ ./hardware-configuration.nix ];

# === BOOT (ключевой момент для BIOS + GPT) ===
boot.loader.grub = {
enable = true;
device = "/dev/sda";     
efiSupport = false;      
useOSProber = false;
};

# Иногда помогает на старых BIOS
boot.loader.grub.version = 2;

# === СИСТЕМА ===
networking.hostName = "nixos";
time.timeZone = "Europe/Moscow";

i18n.defaultLocale = "en_US.UTF-8";
console.keyMap = "us";

# === ПОЛЬЗОВАТЕЛЬ ===
users.users.user = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" ];
initialPassword = "123";
};

# === SUDO ===
security.sudo.wheelNeedsPassword = false;

# === СЕТЬ ===
networking.networkmanager.enable = true;

# === SSH (по желанию) ===
services.openssh.enable = true;

# === БАЗОВЫЕ ПАКЕТЫ ===
environment.systemPackages = with pkgs; [
micro
git
wget
curl
];

# === SSD ТЮНИНГ ===
services.fstrim.enable = true;

# === NIX ===
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# === ВЕРСИЯ СИСТЕМЫ ===
system.stateVersion = "24.11"; # не менять после установки
}

# ОБЯЗАН проверить

# 1. hardware-configuration.nix

# Он должен совпадать с твоей разметкой

lsblk

# Пример 
sda
├─sda1 1M    (bios_grub)
├─sda2 512M  /boot
└─sda3 rest  /

# hardware-configuration.nix
fileSystems."/" = {
  device = "/dev/disk/by-uuid/XXXX";
  fsType = "ext4";
};

fileSystems."/boot" = {
  device = "/dev/disk/by-uuid/YYYY";
  fsType = "ext4";
};

# 2. BIOS boot partition
parted /dev/sda print

# must be
Number 1  ...  bios_grub

# Если нет → GRUB не встанет вообще

# 3. Установка
nixos-install

reboot


