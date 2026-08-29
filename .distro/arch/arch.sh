
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
   i3blocks \
   autotiling-rs \
   fuzzel \
   foot \
   mako \
   wl-clipboard \
   satty \
   grim \
   slurp \
   xdg-desktop-portal-wlr

waybar \

# ----------------------------------
# HYPRLAND
# ----------------------------------

sudo pacman -S \
hyprland \
hyprlock \
hypridle \
hyprpaper \
    uwsm \
    foot \
    rofi-wayland \
    dunst \
    wl-clipboard \
    satty \
    grim \
    slurp \
    swayidle \
    swaylock \
    polkit-kde-agent \
    qt5-wayland \
    qt6-wayland \
    xdg-desktop-portal-hyprland

sudo pacman -S \
   waybar \

# ----------------------------------
# wayle bar
# ----------------------------------

yay -S wayle-bin

sudo pacman -S --needed \
	   git \
      gtk4 \
      gtk4-layer-shell \
      gtksourceview5 \
      libpulse \
      fftw \
      libpipewire \
      systemd-libs \
      clang \
      base-devel \
      bluez \
      bluez-utils \
      networkmanager \
      upower \
      power-profiles-daemon \
      pipewire \
      wireplumber \
      pipewire-pulse

sudo systemctl enable --now bluetooth NetworkManager upower power-profiles-daemon

# ----------------------------------
# seatd
# ----------------------------------

sudo usermod -aG video yopy
sudo systemctl enable --now seatd

sudo systemctl enable --now seatd

