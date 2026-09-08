# ----------------------------------
# SHELL FISH
# ----------------------------------

sudo apt install \
fish \
   eza \
   fzf \
   fd

# go to fish
chsh -s $(command -v fish) 

# ----------------------------------
# set cursor size via terminal
# ---------------------------------- 

xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s 16

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