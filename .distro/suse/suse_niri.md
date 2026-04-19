
# https://en.opensuse.org/openSUSE:LXQt_niri#Installing_LXQt_Niri

 LXQt Niri

user@localhost:~> sudo zypper in lxqt-niri-session

# Go to "Session Settings" in the LXQt Control Center, and select the "Wayland Settings (Experimental)" Icon, and set "Wayland Compositor:" to Niri, and "Screenlock command:" to swaylock

# Logout of LXQt, and select "LXQt (Wayland)" in sddm and login as normal.

# Default Keybindings for LXQt Niri

Super-Shift-a   popup overlay list of configured hotkeys
Super-t           launch terminal (qterminal)
F12             qterminal dropdown
Alt-space       launch lxqt-runner
Super-p           launch filemanager (pcmanfm-qt)
Super-Alt-l     launch logout popup
Super-Shift-esc lock screen
Super-q           close active window
Super-left(h)     focus column to left of active column
Super-right(l)    focus column to right of active column
Super-up(k)       focus window above active window
Super-down(j)     focus window below active window
Super-ctrl-left(h)  move active column to the left
Super-ctrl-right(l) move active column to the right
Super-Ctrl-up(k)    move active window up
Super-Ctrl-down(j)  move active window down
Super-Home        switch focus to first column
Super-End         switch focus to last column
Super-Ctrl-Home   move column to first column
Super-Ctrl-End    move column to last column


# Configuration Files
~/.config/lxqt/wayland

# The Primary file to be concerned with is
~/.config/lxqt/wayland/lxqt-niri.kdl