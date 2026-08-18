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


