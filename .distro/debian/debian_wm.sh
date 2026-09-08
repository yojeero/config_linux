# ----------------------------------
# git
# ----------------------------------
sudo apt update && sudo apt install -y \
   git \
   wget \
   curl 

# ----------------------------------
# SWAY
# ----------------------------------

sudo apt install \
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
   xdg-desktop-portal-gtk \
   nwg-look

# ----------------------------------
#  MANGO
# ----------------------------------

sudo apt install \
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
      slurp \
      nwg-look

# ----------------------------------
# seatd
# ----------------------------------

sudo apt install seatd
sudo systemctl enable --now seatd

sudo usermod -aG video yopy

# ----------------------------------
# pulseaudio
# ----------------------------------

sudo apt install pulseaudio pulseaudio-alsa pavucontrol

systemctl --user enable --now pulseaudio

# ----------------------------------
# PKGS
# ----------------------------------

sudo apt install \

alacritty \
   foot \
   micro \
   mousepad \
   firefox 

thunar \
   thunar-archive-plugin \
   thunar-volman \
   xfce4-screenshooter

fastfetch \
   mc \
   xarchiver \
   tumbler \
   btop 

p7zip-full \
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
   eza \
   fzf \
   fd 

imv \
   celluloid \
   rhythmbox \
   imagemagick \
   ffmpeg \
   libglib2.0-0t64 \
   libglib2.0-dev

# ----------------------------------
# SHELL FISH
# ----------------------------------

sudo apt install fish 

# set fish
chsh -s $(command -v fish) 
