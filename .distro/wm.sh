# ----------------------------------
# SPECTRWM 
# ----------------------------------

git clone https://github.com/Y-Forks/spectrwm
cd spectrwm/linux
make
sudo make install

        alacritty rofi picom feh maim slop xclip dunst i3lock-color wireplumber


chmod +x ~/.config/spectrwm/bar_action.sh
chmod +x ~/.config/spectrwm/.spectrwm.conf

# ----------------------------------
# BSPWM
# ----------------------------------

# bspwm
# git clone https://github.com/Y-Forks/bspwm
# cd bspwm
# make
# sudo make install

# sxhkd
# git clone https://github.com/Y-Forks/sxhkd
# cd sxhkd
# make
# sudo make install

        bspwm sxhkd rofi picom polybar maim slop xclip dunst i3lock-color wireplumber

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh

# ----------------------------------
# SWAY
# ----------------------------------

git clone https://github.com/Y-Forks/sway
cd sway
make
sudo make install

        swaybg swaylock swayidle swaylock-effects \
        foot waybar fuzzel \
        wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# ----------------------------------
# RIVER
# ----------------------------------

# river
git clone https://github.com/Y-Forks/river
cd river
make
sudo make install

        swaybg swaylock swayidle swaylock-effects \
        foot waybar fuzzel \
        wl-clipboard grim slurp mako xdg-desktop-portal-gtk

# ----------------------------------
# PKGS
# ----------------------------------

        firefox alacritty xed micro vim \
        nemo nemo-fileroller \
        bottom fastfetch mc file-roller \
        p7zip unzip zip tumbler \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib2 ripgrep zoxide xfce4-screenshooter \
        celluloid rhythmbox imagemagick ffmpeg palette imv \
        lxappearance xorg-xsetroot   

        thunar thunar-archive-plugin thunar-volman \
        tumbler xarchiver mousepad kitty 
        
        google-chrome visual-studio-code-bin

# ----------------------------------
# SHELL FISH
# ----------------------------------

        fish eza fzf fd

        chsh -s $(command -v fish)

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






