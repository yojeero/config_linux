# ----------------------------------
# SHELL FISH
# ----------------------------------
   fish eza fzf fd

   chsh -s $(command -v fish)

# ----------------------------------
# set cursor size via terminal
# ----------------------------------
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s 16

# ----------------------------------
# HLWM
# ----------------------------------

   herbstluftwm \
   polybar rofi bemenu picom feh \
   maim slop xclip dunst i3lock

# ----------------------------------
# BSPWM
# ----------------------------------

   bspwm sxhkd \
   alacritty polybar rofi picom feh \
   maim slop xclip dunst i3lock

# ----------------------------------
# SWAY
# ----------------------------------
   
   sway swaybg swaylock swayidle swaylock-effects \
   foot waybar fuzzel tofi picom \
   wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# ----------------------------------
# RIVER
# ----------------------------------
   
   river river-tile \
   swaybg swaylock swayidle swaylock-effects \
   foot waybar fuzzel tofi \
   wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# ----------------------------------
# PKGS
# ----------------------------------

   firefox alacritty kitty foot micro mousepad \
   thunar thunar-archive-plugin thunar-volman \
   fastfetch mc xarchiver tumbler btop \
   p7zip unzip zip tar atool \
   wget git curl gvfs udisks2 ntfs-3g \
   xdg-utils ripgrep zoxide xfce4-screenshooter \
   celluloid rhythmbox imagemagick ffmpeg imv \
   lxappearance glib2 gcolor3

# ----------------------------------
# thunar archiver
# ----------------------------------

# thunar archiver in terminal run
xdg-mime default xarchiver.desktop application/zip application/x-tar application/x-7z-compressed application/x-rar

------------------

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
# swaylock-effects Screen lock
# ----------------------------------
# Create a lock script ~/.local/bin/lock.sh:
   
   mkdir -p ~/.local/bin
   touch ~/.local/bin/lock.sh
   chmod +x ~/.local/bin/lock.sh
   
# Open the file and paste the command into it with nice blur and input ring options:
   
   #!/bin/sh
   swaylock \
     --screenshots \
     --clock \
     --indicator \
     --indicator-radius 100 \
     --indicator-thickness 7 \
     --effect-blur 7x5 \
     --effect-vignette 0.5:0.5 \
     --ring-color 81a1c1 \
     --key-hl-color a3be8c \
     --line-color 00000000 \
     --inside-color 2e3440e6 \
     --text-color d8dee9

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

