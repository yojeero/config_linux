
# pkgs
sudo zypper install \
        firefox kitty alacritty \
        nautilus file-roller yazi mc \
        mousepad fastfetch bottom \
        zip unzip p7zip unrar ouch \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib ripgrep zoxide \
        celluloid rhythmbox imagemagick ffmpeg

# SHELL
sudo zypper install fish eza fzf fd

chsh -s $(command -v fish) 

# local rpm install
sudo zypper install vscode.rpm google-chrome.rpm

# ----------------------------------
# bspwm
# ----------------------------------
sudo zypper install bspwm sxhkd rofi picom polybar

# ----------------------------------
# disable gnome support us
# ----------------------------------
gsettings set org.gnome.desktop.privacy disable-donation-notifications true



