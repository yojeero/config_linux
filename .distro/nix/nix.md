
# configuration.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # file manager
    thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman

    # terminal + shell
    kitty
    foot
    fish
    fastfetch
    gnome.gnome-text-editor

    # utils
    wget git gparted btop gvfs udisks2 ntfs3g
    neovim ffmpeg p7zip jq fzf imagemagick lxappearance

    # media / tools
    feh cava dunst imv scrot grim slurp
    celluloid rhythmbox

    # qt
    qt6.qt6ct
    qt5.qt5ct
    qt6.qtwayland

    # hardware / misc
    blueman brightnessctl

    # bspwm stack
    bspwm sxhkd rofi picom polybar

    # fonts
    ubuntu_font_family
    liberation_ttf
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    hack-font

    # extra
    plymouth
    ecryptfs
    curl wget
    python3
    binutils
  ];
}

# gnome
services.xserver.desktopManager.gnome.enable = true;

# remove unused
environment.gnome.excludePackages = (with pkgs.gnome; [
  yelp
  evolution
  gnome-tour
  gnome-weather
  gnome-maps
  gnome-contacts
  gnome-characters
  gnome-music
  gnome-photos
  gnome-terminal
]);

# Fish 
programs.fish.enable = true;

users.users.yourusername = {
  shell = pkgs.fish;
};

# fonts
fonts.packages = with pkgs; [
  ubuntu_font_family
  liberation_ttf
  noto-fonts
  noto-fonts-emoji
  dejavu_fonts
  hack-font
];

# take effect
sudo nixos-rebuild switch

