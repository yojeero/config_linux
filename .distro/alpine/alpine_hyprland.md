
# ============================
# hyprland install
# ============================
apk add hyprland waybar rofi-wayland nwg-look kitty kitty-kitten

# need GPU Mesa driver (mesa-egl for amdgpu and mesa-dri-gallium for amd)
apk add brightnessctl pulseaudio mako grim 
apk add wl-clipboard slurp librsvg swaybg mate-polkit 
apk add fish shell seatd consolekit2 starship lf

# seatd ( wiithout it Hyprland will not work) and maybe more ( you can check my hyprland config)
git clone https://github.com/ronardnx/hyprland_alpinelinux && cd hyprland_alpinelinux && rm -rf .git && cp -r .local/* ~/.local/ && cp -r .config/* ~/.config/

doas setup-devd udev && doas rc-update add elogind && doas rc-update add polkit && chsh -s /usr/bin/fish && doas useradd $USER seat && doas useradd $USER video && doas reboot

# Login from tty and type startx (that s my alias for dbus-run-session Hyprland)

# Cheatsheet:
# mod + D - launches rofi 
# mod + SHIFT + SPACE change the layout from tilling to floating 
# mod + SHIFT + Return launches kitty 
# your stock acpi(Fn + ...) keys for PRINT 
# volume and brightness will work just good.

# packagers
apk add thunar thunar-archive-plugin thunar-volman
apk add kitty fish fastfecth gnome-text-editor 
apk add neovim ffmpeg jq poppler fd fzf imagemagick
apk add xrandr setxkbmap feh dbus btop celluloid rhythmbox
apk add font-inter font-liberation font-terminus-nerd font-jetbrains-mono-nerd
apk add lxappearance p7zip 7zip unzip tar gzip xarchiver
apk add gvfs udisks2 ntfs-3g wget git

apk add yazi gtk-murrine-engine xfce4-power-manager
