
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
# paru
# ----------------------------------

sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
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
# SWAY
# ----------------------------------

paru -S \
sway-git \
   wlroots-git \
   waybar-git \
   swaylock \
   swayidle \
   swaybg \
   wl-clipboard \
   wlogout \
   fuzzel \
   foot \
   mako \
   grim \
   slurp \
   xdg-desktop-portal-wlr \
   xdg-desktop-portal-gtk

# update sway-git 
paru -Sua --devel

# ----------------------------------
#  MANGO
# ----------------------------------

paru -Syu \
mangowm-git \
      swaybg \
      swaylock-effects-git \
      swaync \
      sway-audio-idle-inhibit-git \
      swayidle \
      waybar \
      wlogout \
      foot \
      xdg-desktop-portal-wlr \
      wl-clip-persist \
      cliphist \
      wl-clipboard \
      wlsunset \
      xfce-polkit \
      pamixer \
      wlr-dpms \
      dimland-git \
      brightnessctl \
      swayosd \
      wlr-randr \
      grim \
      slurp

# ----------------------------------
# seatd
# ----------------------------------

sudo pacman -S seatd
sudo systemctl enable --now seatd

sudo usermod -aG video yopy

# ----------------------------------
# pulseaudio
# ----------------------------------

sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol

systemctl --user enable --now pulseaudio

# ----------------------------------
# PKGS
# ----------------------------------

paru -S \

alacritty \
   kitty \
   foot \
   micro \
   mousepad \
   firefox 

thunar \
   thunar-archive-plugin \
   thunar-volman \
   xfce4-terminal

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

