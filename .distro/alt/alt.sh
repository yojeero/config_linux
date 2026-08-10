# https://gist.github.com/Krieger1975/f2f9fd3e99910ecde7c60bd5e78132e7

# user in sudoers

su -

control sudowheel enabled

apt-get update

apt-get dist-upgrade

update-kernel

apt-get clean

remove-old-kernels

apt-get install flatpak

apt-get install flatpak-repo-flathub

# FISH
epm -i fish
su -
usermod yopy -s /usr/bin/fish

# cursor
epmi x-cursor-themes-Bibata

# ----------------------------------
# HLWM 
# ----------------------------------
sudo apt-get update

sudo apt-get -y install git gcc make libX11-devel libXft-devel libXrandr-devel libXcursor-devel libfreetype-devel libbsd-devel libxcbutil-icccm-devel libxcbutil-keysyms-devel libxcbutil-devel libXt-devel

git clone https://github.com/Y-Forks/herbstluftwm
cd herbstluftwm
make
# make clean
sudo make install

herbstluftwm -v

apt-get install alacritty polybar sxhkd rofi picom feh maim slop xclip dunst i3lock dmenu xterm

# xinitrc
apt-get install xinitrc

mkdir -p /usr/share/xsessions

nano /usr/share/xsessions/herbstluftwm.desktop

[Desktop Entry]
Name=herbstluftwm
Comment=herbstluftwm .xinitrc
Exec=xinitrc
Type=Application
DesktopNames=hlwm

# ----------------------------------
# PKGS
# ----------------------------------

apt-get install -y firefox kitty mousepad vim-X11 \
    thunar thunar-archive-plugin thunar-volman-plugin \
    bottom fastfetch mc file-roller tumbler \
    ripgrep zoxide xfce4-screenshooter kcolorchooser GraphicsMagick \
    celluloid rhythmbox ffmpeg imv \
    xsetroot lxde-lxappearance




