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
