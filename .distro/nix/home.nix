{ config, pkgs, ... }:

{
home.username = "user";
home.homeDirectory = "/home/user";
home.stateVersion = "24.11";

home.packages = with pkgs; [
bspwm sxhkd polybar rofi kitty picom feh xclip
nerd-fonts.jetbrains-mono
];

# === bspwm ===

xsession.windowManager.bspwm = {
enable = true;

```
settings = {
  border_width = 2;
  window_gap = 8;
  split_ratio = 0.5;

  normal_border_color = "#45475a";
  active_border_color = "#89b4fa";
  focused_border_color = "#cba6f7";
  presel_feedback_color = "#f38ba8";
};

startupPrograms = [
  "sxhkd"
  "picom"
  "feh --bg-scale ~/wall.jpg"
  "polybar main"
];
```

};

# === sxhkd ===

services.sxhkd = {
enable = true;
keybindings = {
"super + Return" = "kitty";
"super + d" = "rofi -show drun";
"super + q" = "bspc node -c";
"super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
"super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";
"super + r" = "bspc wm -r";
};
};

# === kitty (Catppuccin) ===

programs.kitty = {
enable = true;
settings = {
font_family = "JetBrainsMono Nerd Font";
font_size = 11;

```
  background = "#1e1e2e";
  foreground = "#cdd6f4";

  color0 = "#45475a";
  color8 = "#585b70";

  color1 = "#f38ba8";
  color9 = "#f38ba8";

  color2 = "#a6e3a1";
  color10 = "#a6e3a1";

  color3 = "#f9e2af";
  color11 = "#f9e2af";

  color4 = "#89b4fa";
  color12 = "#89b4fa";

  color5 = "#f5c2e7";
  color13 = "#f5c2e7";

  color6 = "#94e2d5";
  color14 = "#94e2d5";

  color7 = "#bac2de";
  color15 = "#a6adc8";
};
```

};

# === rofi ===

programs.rofi = {
enable = true;
theme = ''
* {
background: #1e1e2e;
foreground: #cdd6f4;
selected: #89b4fa;
}
'';
};

# === picom ===

services.picom = {
enable = true;
backend = "glx";
vSync = true;
settings = {
corner-radius = 8;
shadow = true;
shadow-opacity = 0.5;
inactive-opacity = 0.9;
};
};

# === polybar ===

xdg.configFile."polybar/config.ini".text = ''
[bar/main]
width = 100%
height = 26
background = #1e1e2e
foreground = #cdd6f4
modules-left = workspaces
modules-center = date
modules-right = cpu memory

```
[module/workspaces]
type = internal/xworkspaces

[module/date]
type = internal/date
interval = 5
date = %H:%M

[module/cpu]
type = internal/cpu
interval = 2
format = CPU %percentage%%

[module/memory]
type = internal/memory
interval = 2
format = RAM %percentage_used%%
```

'';

# === bash ===

programs.bash.enable = true;
}

