
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
# SHELL FISH
# ----------------------------------
sudo pacman -S \
fish \
   eza \
   fzf \
   fd

# go to fish
chsh -s $(command -v fish)

# ----------------------------------
# x11
# ----------------------------------

sudo pacman -S \
    xorg-server \
    xorg-xinit \
    xorg-xrandr \
    xorg-xset \
    xorg-xsetroot

# ----------------------------------
# HLWM
# ----------------------------------

sudo pacman -S \
herbstluftwm \
    alacritty \
    polybar \
    rofi \
    picom \
    feh \
    maim \
    slop \
    xclip \
    dunst \
    i3lock

# ----------------------------------
# BSPWM 
# ----------------------------------

sudo pacman -S \
bspwm \
sxhkd \
    alacritty \
    polybar \
    rofi \
    picom \
    feh \
    maim \
    slop \
    xclip \
    dunst \
    i3lock

# ----------------------------------
# PKGS
# ----------------------------------

sudo pacman -S \

alacritty \
   kitty \
   foot \
   micro \
   mousepad \
   firefox 

thunar \
   thunar-archive-plugin \
   thunar-volman

fastfetch \
   mc \
   xarchiver \
   tumbler \
   btop 

p7zip \
   unzip \
   zip \
   tar \
   atool 

wget \
   git \
   curl \
   gvfs \
   udisks2 \
   ntfs-3g 

xdg-utils \
   ripgrep \
   zoxide \
   xfce4-screenshooter 

imv \
   celluloid \
   rhythmbox \
   imagemagick \
   ffmpeg

lxappearance \
   glib2 \
   gcolor3

# ----------------------------------
# SWAY
# ----------------------------------

sudo pacman -S \
swayfx \
swaylock \
swayidle \
swaybg \
   waybar \
   autotiling-rs \
   fuzzel \
   foot \
   mako \
   wl-clipboard \
   satty \
   grim \
   slurp \
   xdg-desktop-portal-wlr \
   xdg-desktop-portal-gtk

# ----------------------------------
#  NIRI
# ----------------------------------

sudo pacman -S \


# ----------------------------------
# seatd
# ----------------------------------

sudo pacman -S seatd
sudo systemctl enable --now seatd

sudo usermod -aG video yopy

