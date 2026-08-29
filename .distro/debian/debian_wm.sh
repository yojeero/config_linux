# ----------------------------------
# x11 make dependencies
# ----------------------------------
sudo apt update && sudo apt install -y git wget curl 

# ----------------------------------
# PKGS
# ----------------------------------
sudo apt install alacritty kitty micro mousepad \
    fastfetch mc xarchiver tumbler btop \
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



