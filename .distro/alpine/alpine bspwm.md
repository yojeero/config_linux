
# =========================
# Bspwm install
# =========================
apk add bspwm sxhkd rofi picom polybar
apk add xterm xf86-video-fbdev xf86-video-vesa font-terminus

# packagers
apk add thunar thunar-archive-plugin thunar-volman gedit gnome-text-editor \ 
                kitty firefox fish fastfecth \ 
                neovim ffmpeg jq poppler fd fzf zoxide imagemagick \ 
                xrandr setxkbmap feh dbus btop celluloid rhythmbox \ 
                font-inter font-liberation font-terminus-nerd font-jetbrains-mono-nerd \ 
                lxappearance p7zip 7zip unzip tar gzip xarchiver \ 
                gvfs udisks2 ntfs-3g wget git

apk add yazi gtk-murrine-engine xfce4-power-manager 

# set fish to shell
fish

# set Picom to autostart
mkdir -p ~/.config/picom

# add this line to your i3 config (.config/i3/config) to autostart Picom
exec --no-startup-id picom --config ~/.config/picom/picom.conf
