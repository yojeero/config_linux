
  # ----------------------------
  # USER
  # ----------------------------
  users.users.yopy = {
    isNormalUser = true;

    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "input"
    ];

    packages = with pkgs; [

      # browsers
      firefox

      # terminals
      kitty
      alacritty

      # shell
      zsh-autosuggestions
      zsh-syntax-highlighting
      eza 
      fzf
      fd

      # cli tools
      micro
      neovim
      mousepad
      fastfetch
      bottom

      # file managers
      yazi
      lf
      vifm
      nautilus
      file-roller

      # utils
      ripgrep     
      zoxide
      xdg-utils
      glib      

      # media
      ffmpeg
      imagemagick
      celluloid
      rhythmbox

      # archives
      zip
      unzip
      p7zip
      unrar
      ouch

      # disk
      wget
      git
      curl
      gvfs
      udisks2
      ntfs-3g

      # themes
      adwaita-icon-theme
      mint-y-icons
    ];
  };

  programs.zsh.enable = true;

  # ----------------------------
  # FONTS
  # ----------------------------
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.terminess-ttf
    adwaita-fonts
  ];


