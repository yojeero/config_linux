# ----------------------------------
#  LXQt River
# ----------------------------------

# https://en.opensuse.org/openSUSE:LXQt_river

 user@localhost:~> sudo zypper in --no-recommends lxqt-river-session

#  Go to "Session Settings" in the LXQt Control Center, and select the "Wayland Settings (Experimental)" Icon, and set "Wayland Compositor:" to River, and "Screenlock command:" to swaylock

# Logout of LXQt, and select "LXQt (Wayland)" in sddm and login as normal.

 zypper in lxqt-river-session

# Default Keybindings for LXQt River

Super-Shift-return     Launch terminal (qterminal)
Super-F12              qterminal dropdown
Alt-space              launch lxqt-runner
Super-Shift-esc        lock screen
Super-q                close active window
Super-Shift-e          logout
Super-j                switch focus-view next
Super-k                switch focus-view previous
Super-Shift-j          swap focus-view next
Super-Shift-k          swap focus-view previous
Super-.                switch focus-output next
Super-,                switch focus-output previous
Super-Shift-.          send focused view to next output
Super-Shift-,          send focused view to previous output
Super-return           bump focused view to top of the layout stack
Super-Alt-h            move focused view left
Super-Alt-j            move focused view down
Super-Alt-k            move focused view up
Super-Alt-l            move focused view right
Super-Alt-Ctrl-h       snap focused view to left screen edge
Super-Alt-Ctrl-j       snap focused view to bottom screen edge
Super-Alt-Ctrl-k       snap focused view to top screen edge
Super-Alt-Ctrl-l       snap focused view to right screen edge
Super-Alt-Shift-h      shrink focused view horizontally
Super-Alt-Shift-j      grow focused view vertically
Super-Alt-Shift-k      shrink focused view vertically
Super-Alt-Shift-l      grow focused view horizontally
Super-space            toggle floating view
Super-f                toggle fullscreen

# Configuration Files
~/.config/lxqt/wayland

# The Primary file to be concerned with is
~/.config/lxqt/wayland/lxqt-river-init