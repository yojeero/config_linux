GNOME 50 + kernel 7

# 1. Переключиться на unstable канал
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update

# configuration.nix
{ config, pkgs, ... }:

{
imports =
[ ./hardware-configuration.nix ];

# === BOOT (BIOS + GPT) ===
boot.loader.grub = {
enable = true;
device = "/dev/sda";
efiSupport = false;
};

# === ЯДРО (максимально свежее) ===
boot.kernelPackages = pkgs.linuxPackages_latest;

# если появится 7.x в канале — он подтянется сам

# === ГРАФИКА / GNOME ===
services.xserver.enable = true;

services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;

# Wayland по умолчанию (на старом железе иногда лучше X11)
services.xserver.displayManager.gdm.wayland = true;

# === ЗВУК ===
services.pipewire = {
enable = true;
pulse.enable = true;
};

# === СЕТЬ ===
networking.networkmanager.enable = true;

# === ПОЛЬЗОВАТЕЛЬ ===
users.users.user = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
initialPassword = "changeme";
};

# === ЛОКАЛЬ ===
time.timeZone = "Europe/Moscow";
i18n.defaultLocale = "en_US.UTF-8";

# === ПАКЕТЫ ===
environment.systemPackages = with pkgs; [
vim git wget curl
];

# === SSD ===
services.fstrim.enable = true;

# === NIX ===
nix.settings.experimental-features = [ "nix-command" "flakes" ];

system.stateVersion = "24.11";
}

---------------------------------------------

# Важные моменты (иначе будешь ловить “чёрный экран”)
# 1. Intel HD (у тебя в Z570)

# Добавь если будут проблемы
services.xserver.videoDrivers = [ "intel" ];

# 2. Если GNOME не стартует (часто на старом железе)

# Попробуй отключить Wayland
services.xserver.displayManager.gdm.wayland = false;