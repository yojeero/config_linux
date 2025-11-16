
# Niri Gentoo

# Add the GURU overlay
sudo eselect repository enable guru
sudo emerge --sync guru

# Install niri
sudo emerge gui-wm/niri

Requirements for Niri

sudo emerge glibc wayland wayland-protocols libinput libdrm libxkbcommon pixman git meson ninja libdisplay-info libliftoff hwdata seatd pcre2 kitty fuzzel swaybg firefox ttf-jetbrains-mono-nerd xwayland-sattelite


niri

# Load Niri

# We’re in niri now by and as you can see, this awesome help tool reminds you of the default kebinds. You can open this at any time with super shift slash.

# Open up .config/niri/config.kdl, and lets change a few keybinds, and options.

prefer-no-csd

# This flag will make niri ask the applications to omit their client-side decorations, so we won’t see this header on alacritty.

# As always, let’s fix the repeat rate and repeat delay, heres how to do it in niri:

input {
    keyboard {
        repeat-delay 200
        repeat-rate 35
    }
}

# For touchpad settings, this is up to you, I prefer ’natural-scroll’ off, but I’ll leave all these options commented out in my config so you guys can adjust them as needed for your preferences.

# And let’s uncomment this so our focus follows our mouse:

focus-follows-mouse max-scroll-amount="0%"

# Let’s add some keybinds here:

    Mod+Return hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
    Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }

    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }
    Mod+Shift+6 { move-column-to-workspace 6; }
    Mod+Shift+7 { move-column-to-workspace 7; }
    Mod+Shift+8 { move-column-to-workspace 8; }
    Mod+Shift+9 { move-column-to-workspace 9; }

# And lets change control to shift here as well for moving things to separate workspaces.

# Now for the layout section, let’s customize the gaps and focus ring:

layout {
    gaps 5

    focus-ring {
        width 1.5
        active-color "#7fc8ff"
        inactive-color "#505050"
    }

    border {
        off
    }
}

# I also like to add some rounded corners to my windows with window rules:

window-rule {
    geometry-corner-radius 4
    clip-to-geometry true
}

# Noctalia Shell + Autostart

# For Gentoo, noctalia-shell can be compiled from source:

# Install quickshell first (dependency)
git clone https://github.com/outfoxxed/quickshell
cd quickshell

# Follow the build instructions in their README

# Then install noctalia-shell
git clone https://github.com/noctalia-dev/noctalia-shell

# Copy the config to ~/.config/quickshell/noctalia
# Lets test to see if we have access to noctalia shell by typing:

`noctalia-shell` `qs -c ~/.config/quickshell/noctalia`

spawn-at-startup "noctalia-shell"

# Noctalia-shell is highly customizable. Here are some of my settings that you can adjust in `~/.

# config/quickshell/noctalia/settings.json`:

{
    "bar": {
        "position": "top",
        "widgets": {
            "left": [
                { "id": "SystemMonitor", "showCpuTemp": true, "showCpuUsage": true, "showMemoryUsage": true },
                { "id": "ActiveWindow", "showIcon": true, "maxWidth": 145 },
                { "id": "MediaMini", "maxWidth": 145 }
            ],
            "center": [
                { "id": "Workspace", "labelMode": "name", "hideUnoccupied": false }
            ],
            "right": [
                { "id": "ScreenRecorder" },
                { "id": "Tray" },
                { "id": "Battery" },
                { "id": "Volume" },
                { "id": "Clock", "formatHorizontal": "HH:mm ddd, MMM dd" },
                { "id": "ControlCenter" }
            ]
        }
    },
    "colorSchemes": {
        "darkMode": true,
        "predefinedScheme": "Tokyo Night"
    },
    "ui": {
        "fontDefault": "JetBrainsMono Nerd Font Propo"
    }
}

# The color scheme is in `~/.config/quickshell/noctalia/colors.json`, and I’m using a Tokyo Night theme.

# Wallpaper

# Actually, if you’re using noctalia-shell, wallpaper management is built right in! Noctalia has a wallpaper selector and can automatically rotate through your wallpapers.

# In your `~/.config/quickshell/noctalia/settings.json`, configure the wallpaper settings:

{
    "wallpaper": {
        "directory": "/home/tony/walls",
        "enabled": true,
        "fillMode": "crop",
        "randomEnabled": true,
        "randomIntervalSec": 300,
        "transitionDuration": 1500
    }
}

# This will automatically handle your wallpapers with smooth transitions. But if you want to use swaybg manually, you can still add it to your niri config:

spawn-sh-at-startup "swaybg -i ~/walls/wall1.png"

# Screenshot Script

# Good news! Niri has a built-in screenshot UI that’s actually really nice. You can trigger it with these keybinds (already in the default config):

Mod+S { screenshot; }
Ctrl+Print { screenshot-screen; }
Alt+Print { screenshot-window; }

# Screenshots are saved to `~/Pictures/Screenshots/` by default, but you can change this in your config:

screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

# If you prefer the traditional grim + slurp workflow, you can still use that:

#!/bin/sh
grim -g "$(slurp)" - | wl-copy

# And bind it in your config.kdl:

Mod+Shift+S { spawn "path-to-your-screenshot-script"; }

# Here’s a summary of my favorite keybinds:

Keybind	Action
Super+Return	Opens a terminal (alacritty)
Super+D	Runs fuzzel (application launcher)
Super+Q	Closes a window
Super+H/J/K/L	Navigate between windows (vim-style)
Super+1-9	Switch to workspace 1-9
Super+Shift+1-9	Move window to workspace 1-9
Super+S	Take a screenshot
Super+O	Toggle Overview mode
Super+F	Maximize column
Super+Shift+F	Fullscreen window
Super+R	Cycle through preset column widths
Super+C	Center the current column
Some advanced features I really like:

Named workspaces - You can create custom named workspaces instead of just numbers:

workspace "a" { }
workspace "b" { }
workspace "c" { }
Window rules - Automatically manage specific applications:

window-rule {
    match title="Firefox"
    open-on-workspace "c"
    open-maximized true
}