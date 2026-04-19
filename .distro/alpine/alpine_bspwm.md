
# =========================
# bspwm install
# =========================
apk add bspwm sxhkd rofi picom polybar
apk add xterm xf86-video-fbdev xf86-video-vesa font-terminus

# packagers
apk add thunar thunar-archive-plugin thunar-volman
apk add kitty fish fastfecth gnome-text-editor
apk add neovim ffmpeg jq poppler fd fzf imagemagick
apk add xrandr setxkbmap feh dbus btop celluloid rhythmbox
apk add font-inter font-liberation font-terminus-nerd font-jetbrains-mono-nerd
apk add lxappearance p7zip 7zip unzip tar gzip xarchiver
apk add gvfs udisks2 ntfs-3g wget git

apk add yazi gtk-murrine-engine xfce4-power-manager 

# set fish to shell
fish

# set Picom to autostart
mkdir -p ~/.config/picom
