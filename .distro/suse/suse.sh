
# pkgs
sudo zypper install \
        firefox kitty alacritty mousepad \
        thunar thunar-archive-plugin thunar-volman \
        bottom fastfetch yazi mc file-roller \
        p7zip unzip zip ouch \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib ripgrep zoxide \
        celluloid rhythmbox imagemagick ffmpeg \
        jetbrains-mono-fonts symbols-only-nerd-fonts

# SHELL
sudo zypper install fish eza fzf fd

chsh -s $(command -v fish) 

# local rpm install
sudo zypper install vscode.rpm google-chrome.rpm

# ----------------------------------
# bspwm
# ----------------------------------
sudo zypper install bspwm sxhkd rofi picom polybar feh dunst maim slop xclip




