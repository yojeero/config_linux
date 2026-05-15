
# clean GNOME
sudo emerge --ask --depclean \
            yelp evolution thunderbird gnome-tour \
            gnome-software gnome-weather gnome-klotski \
            gnome-mahjong gnome-chess gnome-games gnome-mines \
            gnome-nibbles gnome-robots gnome-sudoku gnome-sushi \
            gnome-taquin gnome-tetravex gnome-characters gnome-maps \
            gnome-contacts gnome-2048 swell-foop aisleriot shotwell \
            libreoffice libreoffice-common xfburn xfce4-dict

# pkgs
sudo emerge --ask \
        firefox kitty ghostty \
        nautilus file-roller yazi \
        mousepad fastfetch bottom \
        zip unzip p7zip unrar ouch \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib ripgrep zoxide \
        celluloid rhythmbox imagemagick ffmpeg \
        adwaita-icon-theme mint-y-icons

# SHELL
sudo emerge --ask fish eza fzf fd

# local rpm install
sudo emerge --ask vscode.rpm google-chrome.rpm

# ubuntu look
sudo emerge --ask \
            plymouth ecryptfs-utils python-is-python3 binutils \
            fonts-noto-core fonts-hack \
            gnome-shell-extension-manager gnome-tweaks gnome-shell-extensions \
            gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock \
            gnome-shell-extension-appindicator gnome-shell-extension-system-monitor \
            yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound \
            yaru-theme-unity gnome-package-updater gnome-packagekit

# fist starship
sudo emerge --ask app-shells/starship

mkdir -p ~/.config/fish
nano ~/.config/fish/config.fish

# Инициализация Starship промпта
starship init fish | source







