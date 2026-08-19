
# ----------------------------------
# update
# ----------------------------------

sudo pacman -Syu

# ----------------------------------
# yay
# ----------------------------------

sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# ----------------------------------
# arch + bspwm 
# ----------------------------------

sudo pacman -S \
    xorg-server xorg-xinit \
    xorg-xrandr xorg-xset xorg-xsetroot

sudo pacman -S \
    bspwm sxhkd \
    alacritty polybar rofi bemenu picom feh \
    maim slop xclip dunst i3lock 

sudo pacman -S \
    firefox kitty micro mousepad \
    thunar thunar-archive-plugin thunar-volman \
    gvfs udisks2 ntfs-3g tumbler \
    fastfetch mc engrampa btop \
    p7zip unzip zip tar atool \
    wget git curl xdg-utils ripgrep zoxide \
    xfce4-screenshooter celluloid rhythmbox imv \
    imagemagick ffmpeg lxappearance glib2

# ----------------------------------
# pipeware audio
# ----------------------------------

sudo pacman -S \
    pipewire pipewire-audio pipewire-pulse pipewire-alsa pipewire-jack wireplumber

systemctl --user enable --now pipewire.socket
systemctl --user enable --now pipewire-pulse.socket
systemctl --user enable --now wireplumber.service

pactl info
