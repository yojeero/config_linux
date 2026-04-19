# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
curl -fsSL https://install.danklinux.com | sh

Installation

# 1. Enable NixOS Unstable

# Ensure you're using NixOS unstable by setting your channel or flake input:

# Using channels:

sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update

Using flakes (in flake.nix):

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
}

# 2. Enable DankMaterialShell

# In your NixOS configuration, enable DankMaterialShell:

programs.dms-shell.enable = true;

# That's it! Rebuild your system and DankMaterialShell will be installed with sensible defaults.

# Configuration Options

# DankMaterialShell provides numerous configuration options to customize your installation. Here are the main options:

Feature Toggles
programs.dms-shell = {
  enable = true;

  systemd = {
    enable = true;             # Systemd service for auto-start
    restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
  };
  
  # Core features
  enableSystemMonitoring = true;     # System monitoring widgets (dgop)
  enableVPN = true;                  # VPN management widget
  enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
  enableAudioWavelength = true;      # Audio visualizer (cava)
  enableCalendarEvents = true;       # Calendar integration (khal)
  enableClipboardPaste = true;       # Pasting from the clipboard history (wtype)
};

# Custom Quickshell Package
# If you need a specific version of Quickshell:

programs.dms-shell = {
  enable = true;
  quickshell.package = pkgs.quickshell; # or your custom package
};

# Using Quickshell from Source

# Many features in DankMaterialShell rely on unreleased Quickshell features. For the best experience, you may want to use Quickshell built from source.

# To use Quickshell from source, add it as a flake input:

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

# Then use it in your configuration:

programs.dms-shell = {
  enable = true;
  quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
};

# Using Flake Package with NixOS Module

# You can use the package from the DankMaterialShell flake while still using the native NixOS module. This allows you to get quicker updates while keeping the module configuration:

# First, add the flake input to your flake.nix:

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

# Plugins

# Install DankMaterialShell plugins declaratively. There are two methods:

# Method 1: Using the Plugin Registry (Recommended)

# The dms-plugin-registry flake provides all community plugins as packages with daily updates. This is the simplest way to install plugins.

# First, add the plugin registry as a flake input:

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

# Then import the module and enable plugins:

{
  imports = [ inputs.dms-plugin-registry.modules.default ];

  programs.dms-shell = {
    enable = true;

    plugins = {
      # Simply enable plugins by their ID (from the registry)
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
    };
  };
}

# The plugin IDs can be found in the plugin store - it's the last part of the install URL. For example, dms://plugin/install/dankBatteryAlerts has the ID dankBatteryAlerts.

# Method 2: Manual Installation from Source

# If you don't want to use the registry flake, you can install plugins manually by providing the source:

programs.dms-shell = {
  enable = true;

  plugins = {
    dockerManager = {
      src = pkgs.fetchFromGitHub {
        owner = "LuckShiba";
        repo = "DmsDockerManager";
        rev = "v1.2.0";
        sha256 = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
      };
    };
    anotherPlugin = {
      enable = true;
      src = pkgs.another-plugin;
    };
  };
};

# Compositor Config Files

# The NixOS module installs DMS but doesn't generate compositor-specific config files (keybinds, colors, layout, etc.). Use dms setup to deploy the defaults for your compositor, or generate individual configs:

# # Deploy all defaults
dms setup

# Or pick and choose
dms setup binds
dms setup colors
dms setup layout

# See the Setup CLI reference for the full list of subcommands.

# Advanced Configuration

# For a complete list of available options, check the module file in nixpkgs.

# Rebuilding

# After making configuration changes, rebuild your system:

sudo nixos-rebuild switch

# Troubleshooting

# DMS doesn't start automatically
# Make sure you have systemd.enable = true set:

programs.dms-shell = {
  enable = true;
  systemd.enable = true;
};

# Missing dependencies
# Each feature has its own dependency set. If a feature isn't working, ensure the corresponding enable option is set to true. For example, clipboard history pasting requires enableClipboardPaste = true which installs wtype.