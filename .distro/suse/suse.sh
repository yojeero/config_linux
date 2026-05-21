
# gnome remove
sudo zypper remove \
        yelp evolution thunderbird gnome-tour \
        gnome-software gnome-weather gnome-klotski \
        gnome-mahjong gnome-chess gnome-games gnome-mines \
        gnome-nibbles gnome-robots gnome-sudoku gnome-sushi \
        gnome-taquin gnome-tetravex gnome-characters gnome-maps \
        gnome-contacts gnome-2048 swell-foop aisleriot shotwell \
        libreoffice libreoffice-common xfburn xfce4-dict

# pkgs
sudo zypper install \
        firefox kitty ghostty \
        nautilus file-roller yazi \
        mousepad fastfetch bottom \
        zip unzip p7zip unrar ouch \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib ripgrep zoxide \
        celluloid rhythmbox imagemagick ffmpeg \
        adwaita-icon-theme mint-y-icons

# SHELL
sudo zypper install fish eza fzf fd

chsh -s $(command -v fish) 

# local rpm install
sudo zypper install vscode.rpm google-chrome.rpm

# ubuntu look
sudo zypper install \
            plymouth ecryptfs-utils python-is-python3 binutils \
            fonts-noto-core fonts-hack \
            gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions \
            gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock \
            gnome-shell-extension-appindicator gnome-shell-extension-system-monitor \
            yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound \
            yaru-theme-unity gnome-package-updater gnome-packagekit

# ----------------------------------
# bspwm
# ----------------------------------

sudo zypper install bspwm sxhkd rofi picom polybar

# disable gnome support us
gsettings set org.gnome.desktop.privacy disable-donation-notifications true



