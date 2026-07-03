# ----------------------------------
# Переключение сети на NetworkManager
# ----------------------------------

# Разрешите NetworkManager управлять кабелем
sudo nano /etc/NetworkManager/NetworkManager.conf

# Найдите строку managed=false и замените её на 
managed=true 

# Закомментировать, относящиеся к вашему сетевому интерфейсу (обычно они выглядят как allow-hotplug eth0 и iface eth0 inet dhcp). 
# Строки source /etc/network/interfaces.d/* и auto lo трогать не нужно. 

# pkgs
sudo apt update
sudo apt install -y \
            firefox kitty alacritty mousepad\
            thunar thunar-archive-plugin thunar-volman \
            bottom fastfetch yazi mc file-roller \
            p7zip unzip zip ouch \
            wget git curl gvfs udisks2 ntfs-3g \
            xdg-utils glib ripgrep zoxide \
            celluloid rhythmbox imagemagick ffmpeg \
            fonts-jetbrains-mono ttf-nerd-fonts-symbols

# nerd fonts installer
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# SHELL
sudo apt install -y fish eza fzf fd

chsh -s $(command -v fish)

# ----------------------------------
# BSPWM
# ----------------------------------
sudo apt install -y bspwm sxhkd rofi picom polybar feh dunst maim slop xclip

# ----------------------------------
# repo+system
# ----------------------------------

sudo apt-add-repository -y non-free contrib 

sudo apt install -y linux-headers-amd64

sudo systemctl enable --now fstrim.timer

sudo nano /etc/apt/sources.list.d/debian.sources

# В строке Components: через пробел допишите 
Components: main contrib non-free non-free-firmware

sudo apt update