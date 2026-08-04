
{ config, lib, pkgs, ... }:

{

  imports = [ ./hardware-configuration.nix ];

# uefi
# boot.loader.systemd-boot.enable = true;
# boot.loader.efi.canTouchEfiVariables = true;

# mbr
boot.loader.systemd-boot.enable = false;
boot.loader.efi.canTouchEfiVariables = false;
boot.loader.grub.enable = true;
boot.loader.grub.device = "/dev/sda";

nix.settings.experimental-features = [ "nix-command" "flakes" ];

networking.hostName = "laptop-lenovo";
networking.networkmanager.enable = true;

# only for lenovo
boot.kernelParams = [ "reboot=pci" ];
hardware.enableAllFirmware = true;
nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Moscow";

services.xserver = {
  enable = true;

# Enable spectrwm
  windowManager.spectrwm.enable = true;

# Disable the default display manager to boot into TTY
  displayManager.startx.enable = true;

# Setting up the keyboard layout (Alt+Shift to change the language)
  xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

 displayManager.sessionCommands = ''
    exec spectrwm
  '';

};

environment.systemPackages = with pkgs; [
    rofi        
    alacritty    
    git
    picom
    feh
    xed
    fastfetch
    dunst
    xclip
    maim
    slop
    xsetroot
    firefox
    nemo
    nemo-fileroller
    file-roller
    gvfs
    udisks
    gdk-pixbuf
    micro
    vim
    mc
    bottom
    celluloid
    imagemagick
    ffmpeg 
    ffmpegthumbnailer
    imv
    xorg-apps
    lxappearance
    i3lock-color
    fish
    curl
    wl-clipboard
];

fonts.packages = with pkgs; [
  noto-fonts
  jetbrains-mono
  (nerdfonts.override {
    fonts = [ "JetBrainsMono" ];
  })
];

programs.fish.enable = true;

# Allow users to change passwords
users.mutableUsers = true;

users.users.yopy = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  shell = pkgs.fish; 
  
# Temporary password (change it with `passwd` command after boot)
  initialPassword = "123"; 
};

# You can also leave the password for root just in case
users.users.root.initialPassword = "123";

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
  services.libinput.enable = true;
  services.fwupd.enable = true;

  # GPU
  hardware.graphics = {
    extraPackages = with pkgs; [ intel-vaapi-driver intel-media-driver ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = false;

system.stateVersion = "24.11";

environment.etc."fish/conf.d/startx.fish".text = ''
  if status is-login
    if test (tty) = "/dev/tty1"
      exec startx
    end
  end
'';


}
