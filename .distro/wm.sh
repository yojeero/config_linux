
# ----------------------------------
# SHELL FISH
# ----------------------------------

fish \
   eza \
   fzf \
   fd

# go to fish
chsh -s $(command -v fish)

# ----------------------------------
# x11
# ----------------------------------

xorg-server \
    xorg-xinit \
    xorg-xrandr \
    xorg-xset \
    xorg-xsetroot

# ----------------------------------
# HLWM
# ----------------------------------

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

waybar \

# ----------------------------------
# wayle bar
# ----------------------------------

wayle-bin \
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
# PKGS
# ----------------------------------

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
# thunar archiver
# ----------------------------------

# Fast unpack
# Command 
mkdir -p "${F%.*}" && cd "${F%/*}" && if [ "${F##*.}" = "zip" ]; then unzip "%f" -d "${f%.*}"; elif [ "${F##*.}" = "rar" ]; then unrar x "%f" "${f%.*}"; else 7z x "%f" -o"${f%.*}"; fi

---------

# Unpack ALL selections
# Command
for f in %F; do if [ "${f##*.}" = "zip" ]; then unzip -o "$f" -d "${f%.*}"; else 7z x -y "$f" -o"${f%.*}"; fi; done

---------------------

# Compress each into a separate .tar.xz
# Command
for f in %F; do tar -cJf "${f%%/}.tar.xz" -C "$(dirname "$f")" "$(basename "$f")"; done

# ----------------------------------
# mpd ncmpcpp
# ----------------------------------

# ncmpcpp (NCurses Music Player Daemon Client Plus Plus) -console audio player. 
# To make it play, we need to install and configure MPD (Music Player Daemon) -a background server that will play music and send sound to our configured PipeWire.
sudo apt install --no-install-recommends mpd ncmpcpp

# By default, Ubuntu runs MPD as a global system service, which often causes problems accessing user audio cards. We will disable the system daemon and configure it locally for your user.
sudo systemctl stop mpd
sudo systemctl disable mpd

# We will create directories for configs, playlists and the music itself in your home directory
mkdir -p ~/.config/mpd ~/.local/share/mpd/playlists ~/Music

# look in config
nano ~/.config/mpd/mpd.conf

# run buy user
mpd

# Let's create a configuration file to beautifully display the playlist and enable the built-in spectral visualizer
mkdir -p ~/.config/ncmpcpp
nano ~/.config/ncmpcpp/config

# mpd ncmpcpp using
# 1. copy yours .mp3 or .flac in folder ~/Music.
# 2. ncmpcpp
# 3. Press the u (English) key to refresh the MPD database and see your tracks.

# Basic hotkeys in ncmpcpp:
# 1 - Current playlist.
# 2 - File browser (browsing through folders in ~/Music). 
# Press Space to add the song/folder to the queue.
# 8 — Sound visualizer (same spectrogram).
# Enter -Play the selected track.
# s — Stop, 
# p -Pause.
# > /< — Next /previous track.
# q -Exit ncmpcpp (music will continue to play in the background, since MPD is a daemon).

