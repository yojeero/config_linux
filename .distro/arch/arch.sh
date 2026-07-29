# update
sudo pacman -Syu

# yay
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S \
        firefox kitty alacritty mousepad\
        thunar thunar-archive-plugin thunar-volman \
        bottom fastfetch mc file-roller \
        p7zip unzip zip \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib2 ripgrep zoxide xfce4-screenshooter \
        celluloid rhythmbox imagemagick ffmpeg palette imv \
	lxappearance kvantum qt6ct xorg-xsetroot \
        ttf-jetbrains-mono ttf-nerd-fonts-symbols adwaita-fonts 
    
yay -S google-chrome visual-studio-code-bin

# SHELL
pacman -Sy fish eza fzf fd

chsh -s $(command -v fish)

# ----------------------------------
# BSPWM
# ----------------------------------
pacman -S bspwm sxhkd rofi picom polybar feh dunst maim slop xclip

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh

# ----------------------------------
# sway
# ----------------------------------
yay -S \
    sway swaybg swaylock swayidle swaylock-effects \
    foot waybar fuzzel \
    wl-clipboard grim slurp \
    mako xdg-desktop-portal-gtk

# ----------------------------------
# spectrwm 
# ----------------------------------
yay -S spectrwm alacritty rofi maim slop xclip feh picom dunst i3lock-color xkb-switch wireplumber


