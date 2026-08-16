# ----------------------------------
# x11 make dependencies
# ----------------------------------
sudo apt update && sudo apt install -y git wget curl 

# ----------------------------------
# PKGS
# ----------------------------------
sudo apt install alacritty kitty micro \
    fastfetch mc engrampa tumbler btop \
    p7zip-full unzip zip unrar-free tar atool \
    wget git curl gvfs udisks2 ntfs-3g \
    xdg-utils ripgrep zoxide xfce4-screenshooter \
    celluloid rhythmbox imagemagick ffmpeg imv \
    lxappearance libglib2.0-0t64 libglib2.0-dev

# ----------------------------------
# SHELL FISH
# ----------------------------------
sudo apt install fish eza fzf 
chsh -s $(command -v fish)

# ----------------------------------
# wayland
# ----------------------------------
sudo apt install sway swaybg swaylock swayidle swaylock-effects \
        foot waybar fuzzel picom \
        wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# Launch Wayland sessions, explicitly specifying the backend for the libraries
nano ~/.profile

export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1 # Для Firefox

# ----------------------------------
# autostart scipt
# ----------------------------------
nano ~/.bash_profile

# If this is an interactive session and we are on the first virtual console (TTY1)
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    
    echo "---------------------------------------"
    echo " Выберите графическое окружение:"
    echo " 1) River (Wayland)"
    echo " 3) Остаться в консоли (TTY)"
    echo "---------------------------------------"
    read -p "Ваш выбор [1-3]: " choice

    case $choice in
        1)
            export XDG_SESSION_TYPE=wayland
            export XDG_CURRENT_DESKTOP=river
            export MOZ_ENABLE_WAYLAND=1
            
# Launch River (via dbus for PipeWire integration)
            exec dbus-run-session river
            ;;
        2)
# Start an X11 session (calls your ~/.xinitrc)
            exec startx
            ;;
        *)
           echo "We remain in the console. To start graphics, reboot the session."
            ;;
    esac
fi

# ----------------------------------
# launch River (Wayland)
# ----------------------------------
mkdir -p ~/.config/river

# Setting environment variables within a session
riverctl spawn "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

chmod +x ~/.config/river/init
