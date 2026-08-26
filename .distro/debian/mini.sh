# ----------------------------------
# SHELL FISH
# ----------------------------------
sudo apt install fish eza fzf

chsh -s $(command -v fish)

# ----------------------------------
# set cursor size via terminal
# ---------------------------------- 
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s 16

# ----------------------------------
# PKGS
# ----------------------------------
sudo apt install alacritty kitty micro \
    fastfetch mc xarchiver tumbler btop \
    p7zip-full unzip zip tar atool \
    wget git curl gvfs udisks2 ntfs-3g \
    xdg-utils ripgrep zoxide xfce4-screenshooter \
    celluloid rhythmbox imagemagick ffmpeg imv \
    lxappearance libglib2.0-0t64 libglib2.0-dev

# ----------------------------------
# HLWM
# ----------------------------------
sudo apt install \
   herbstluftwm \
   alacritty polybar rofi picom feh \
   maim slop xclip dunst i3lock

# ----------------------------------
# BSPWM
# ----------------------------------
sudo apt install \
   bspwm sxhkd \
   alacritty polybar rofi picom feh \
   maim slop xclip dunst i3lock

# ----------------------------------
# SWAY
# ----------------------------------
sudo apt install \
   sway swaybg swaylock swayidle swaylock-effects \
   foot waybar fuzzel picom \
   wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# ----------------------------------
# RIVER
# ----------------------------------
sudo apt install \
   river river-tile \
   swaybg swaylock swayidle swaylock-effects \
   foot waybar fuzzel \
   wl-clipboard grim slurp mako xdg-desktop-portal-gtk
