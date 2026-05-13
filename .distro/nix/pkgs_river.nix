# configuration.nix:

services.xserver.displayManager.gdm.enable = true; 
programs.river.enable = true;


# for browsers and screenshots to work in Wayland
xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
};

# Firefox XWayland
home.sessionVariables = {
  MOZ_ENABLE_WAYLAND = "1";
};

# ======================================

{ pkgs, ... }:

{
  programs.sway = {
    enable = true;

    wrapperFeatures.gtk = true;

    xwayland.enable = true;
  };

  xdg.portal = {
  enable = true;
  wlr.enable = true;

  extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
};

  environment.systemPackages = with pkgs; [
    foot
    fuzzel
    mako

    grim
    slurp
    wl-clipboard

    swaylock
    swayidle
    swaybg
    waybar
    swaylock-effects
  ];
}
