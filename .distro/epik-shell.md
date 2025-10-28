
# shell for for hyprland 
# https://github.com/ezerinz/epik-shell/

sudo pacman -S libastal-meta libastal-gjs-git dart-sass \ 
              esbuild hyprpicker swappy wf-recorder wayshot \ 
              slurp wl-copy brightnessctl

# Quick Start Guide

git clone https://github.com/ezerinz/epik-shell
cd epik-shell
LD_PRELOAD=/usr/lib/libgtk4-layer-shell.so gjs -m build.js

# Configuration
# Epik Shell looks for a configuration file in the config directory (~/.config/epik-shell/config.json). 

# Warning - Don't copy and paste this entire block into your config.json, just edit yours config.

# config.json

{
  "dock": {
    "position": "bottom", // "top" | "bottom"
    "pinned": ["firefox", "Alacritty", "org.gnome.Nautilus", "localsend"], // array of application classname
  },
  "bar": {
    "position": "top", // "top" | "bottom"
    "separator": true,
    // modules to show in start, center, and end of bar.
    // available options: "launcher", "workspace", "time", "notification", "network_speed", "quicksetting"
    "start": ["launcher", "workspace"],
    "center": ["time", "notification"],
    "end": ["network_speed", "quicksetting"],
  },
  "desktop_clock": {
    "position": "top_left", // "top_left" | "top" | "top_right" | "left" | "center" | "right" | "bottom_left" | "bottom" | "bottom_right"
  },
  "theme": {
    "bar": {
      "bg_color": "$bg", // css color values (name -> red, rgb -> rgb(50, 50, 50), etc), or use theme color with "$" prefix ($bg, $accent, etc)
      "opacity": 1,
      "border_radius": 6, // in px, support css style (top, right, bottom, left -> [10, 15, 20, 10])
      "margin": 10, // in px, support css style
      "padding": 3, // in px, support css style
      "border_width": 2,
      "border_color": "$fg", // css color values or use theme color
      "shadow": {
        "offset": [6, 6], // in px, can be [horizontal, vertical] or single number
        "blur": 0,
        "spread": 0,
        "color": "$fg", // css color values or use theme color
        "opacity": 1,
      },
      "button": {
        "bg_color": "$bg",
        "fg_color": "$fg",
        "opacity": 1,
        "border_radius": 8,
        "border_width": 0,
        "border_color": "$fg",
        "padding": [0, 4],
        "shadow": {
          "offset": [0, 0],
          "blur": 0,
          "spread": 0,
          "color": "$fg",
          "opacity": 1,
        },
      },
    },
    "window": {
      "opacity": 1,
      "border_radius": 6,
      "margin": 10,
      "padding": 10,
      "dock_padding": 4,
      "desktop_clock_padding": 4,
      "border_width": 2,
      "border_color": "$fg",
      "shadow": {
        "offset": [6, 6],
        "blur": 0,
        "spread": 0,
        "color": "$fg",
        "opacity": 1,
      },
    },
    "light": {
      "bg": "#fbf1c7",
      "fg": "#3c3836",
      "accent": "#3c3836",
      "red": "#cc241d",
    },
    "dark": {
      "bg": "#282828",
      "fg": "#ebdbb2",
      "accent": "#ebdbb2",
      "red": "#cc241d",
    },
  },
}

