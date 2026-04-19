X11 + bspwm + sxhkd


# flakes
/etc/nixos/
├── flake.nix
├── hosts/minimal.nix
├── modules/
│   ├── core.nix
│   ├── x11-bspwm.nix
│   └── packages-minimal.nix

# flake.nix
{
  description = "Ultra minimal NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/minimal.nix
      ];
    };
  };
}

# hosts/minimal.nix
{ pkgs, ... }:

{
  imports = [
    ../modules/core.nix
    ../modules/x11-bspwm.nix
    ../modules/packages-minimal.nix
  ];

  networking.hostName = "ultra";

  users.users.yojee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  system.stateVersion = "24.11";
}

# modules/core.nix 
{ pkgs, ... }:

{
  # 🔥 агрессивная минимизация
  documentation.enable = false;
  documentation.nixos.enable = false;

  # отключить ненужное
  services.printing.enable = false;   # cups
  services.avahi.enable = false;
  services.xserver.libinput.enable = true;

  # сеть
  networking.networkmanager.enable = true;

  # звук
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # базовая локаль
  i18n.defaultLocale = "en_US.UTF-8";

  # timezone
  time.timeZone = "Europe/Berlin";

  # базовые пакеты системы
  environment.defaultPackages = [ ];  # ❗ убираем дефолтный мусор

  # меньше closure
  nix.settings.auto-optimise-store = true;
}

# modules/x11-bspwm.nix
{ pkgs, ... }:

{
  services.xserver.enable = true;

  # ❗ без display manager
  services.xserver.displayManager.startx.enable = true;

  # ❗ только bspwm
  services.xserver.windowManager.bspwm.enable = true;

  services.xserver.desktopManager.xterm.enable = false;

  # минимальный X набор
  services.xserver.excludePackages = [ pkgs.xterm ];
}

# modules/packages-minimal.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # shell / terminal
    fish
    kitty

    # wm stack
    bspwm sxhkd

    # launcher
    rofi

    # bar + compositor
    polybar picom

    # notifications
    dunst

    # files
    thunar

    # cli essentials
    neovim git curl wget
    htop fzf jq

    # utils
    unzip p7zip
    brightnessctl playerctl

    # media
    mpv imv

    # screenshots
    scrot

    # wallpaper
    feh

    # fonts (минимум)
    jetbrains-mono
    noto-fonts-emoji
  ];
}

# start
sudo nixos-rebuild switch --flake /etc/nixos#minimal
startx

# Проверить количество пакетов
nix-store -q --requisites /run/current-system | wc -l

~180–230