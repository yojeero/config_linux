
{ config, lib, pkgs, ... }:

{

  imports = [ ./hardware-configuration.nix ];

# uefi
# boot.loader.systemd-boot.enable = true;
# boot.loader.efi.canTouchEfiVariables = true;
boot.loader.systemd-boot.enable = false;
boot.loader.efi.canTouchEfiVariables = false;

# only for mbr
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

  # Включаем spectrwm
  windowManager.spectrwm.enable = true;

  # Отключаем дефолтный дисплейный менеджер, чтобы загружаться в TTY
  displayManager.startx.enable = true;

  # Настройка раскладки клавиатуры (Alt+Shift для смены языка)
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
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.adwaita-mono
    nerd-fonts.jetbrains-mono
    lato
  ];


programs.fish.enable = true;

# Разрешаем менять пароли пользователям
users.mutableUsers = true;

users.users.yopy = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  shell = pkgs.fish; 
  
  # Временный пароль (смените его командой `passwd` после загрузки)
  initialPassword = "your-user-password"; 
};

# Пароль для root тоже можно оставить на всякий случай
users.users.root.initialPassword = "your-root-password";

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

# Автозапуск startx для fish в первом терминале (TTY1)
home-manager.users.yopy = {}; # Если решите использовать home-manager позже

environment.etc."fish/conf.d/startx.fish".text = ''
  if status is-login
    if test (tty) = "/dev/tty1"
      exec startx
    end
  end
'';


}
