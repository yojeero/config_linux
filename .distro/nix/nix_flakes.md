# project

/etc/nixos/
├── flake.nix
├── hosts/
│   └── default/
│       └── configuration.nix
├── modules/
│   ├── packages.nix
│   ├── gnome.nix
│   ├── bspwm.nix
│   └── fonts.nix

# flake.nix
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/default/configuration.nix
      ];
    };
  };
}

# hosts/default/configuration.nix
{ config, pkgs, ... }:

{
  imports = [
    ../../modules/packages.nix
    ../../modules/fonts.nix
    ../../modules/gnome.nix
    ../../modules/bspwm.nix
  ];

  networking.hostName = "myhost";

  # user
  users.users.yojee = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # boot
  boot.plymouth.enable = true;

  system.stateVersion = "24.11";
}

# modules/packages.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # file manager
    thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman

    # terminal
    kitty foot fish fastfetch
    gnome.gnome-text-editor

    # system utils
    wget git gparted btop gvfs udisks2 ntfs3g

    # cli
    neovim ffmpeg p7zip jq fzf imagemagick lxappearance

    # media
    feh cava dunst imv scrot grim slurp
    celluloid rhythmbox

    # qt
    qt6.qt6ct qt5.qt5ct qt6.qtwayland

    # hardware
    blueman brightnessctl

    # misc
    plymouth ecryptfs curl python3 binutils
  ];
}

# modules/gnome.nix
{ pkgs, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs.gnome; [
    yelp
    evolution
    gnome-tour
    gnome-maps
    gnome-weather
    gnome-contacts
    gnome-characters
  ]);

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.extension-manager

    yaru-theme
  ];
}

# modules/bspwm.nix
{ pkgs, ... }:

{
  services.xserver.windowManager.bspwm.enable = true;

  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    rofi
    picom
    polybar
  ];
}

# modules/fonts.nix
{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    ubuntu_font_family
    liberation_ttf
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    hack-font
  ];
}



# enable flakes if not
sudo nano /etc/nixos/configuration.nix

# insert
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# use
sudo nixos-rebuild switch --flake /etc/nixos#myhost