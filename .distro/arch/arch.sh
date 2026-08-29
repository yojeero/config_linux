
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
# ARCH + BSPWM 
# ----------------------------------

sudo pacman -S \
    xorg-server xorg-xinit \
    xorg-xrandr xorg-xset xorg-xsetroot

sudo pacman -S \
    bspwm sxhkd \
    alacritty polybar rofi picom feh \
    maim slop xclip dunst i3lock 

sudo pacman -S \
   firefox alacritty kitty micro mousepad \
   thunar thunar-archive-plugin thunar-volman \
   fastfetch mc xarchiver tumbler btop \
   p7zip unzip zip tar atool \
   wget git curl gvfs udisks2 ntfs-3g \
   xdg-utils ripgrep zoxide xfce4-screenshooter \
   celluloid rhythmbox imagemagick ffmpeg imv \
   lxappearance glib2 gcolor3

# ----------------------------------
# HYPRLAND
# ----------------------------------

sudo pacman -S hyprland wl-clipboard

#wayle bar
yay -S wayle-bin

sudo pacman -S --needed \
	git gtk4 gtk4-layer-shell gtksourceview5 \
  	libpulse fftw libpipewire \
	systemd-libs clang base-devel

sudo pacman -S --needed \
	bluez bluez-utils networkmanager upower \
  	power-profiles-daemon \
	pipewire wireplumber pipewire-pulse

sudo systemctl enable --now bluetooth NetworkManager upower power-profiles-daemon

# seatd
sudo usermod -aG video yopy
sudo systemctl enable --now seatd

sudo systemctl enable --now seatd

# -------------------------------
# LightDM remove
# -------------------------------

sudo systemctl disable lightdm.service
sudo pacman -R lightdm lightdm-gtk-greeter

#  Создайте и настройте файл .xinitrc

cp /etc/X11/xinit/xinitrc ~/.xinitrc

nano ~/.xinitrc

# Scroll to the bottom of the file. Remove or comment out the standard startup lines with twm &, xclock & and ending with exec xterm....

# At the very end of the file add lines to run sxhkd + bspwm

sxhkd &
exec bspwm

sudo chown -R yopy:yopy ~/.xinitrc ~/.Xauthority

# To configure bspwm to start automatically immediately after entering the login and password into the tty (bypassing manual entry of startx), you need to add a special condition to the fish shell configuration file

nano ~/.config/fish/config.fish

# Add to the end of the file 
# Autostart X11 when logging into tty1

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx
    end
end

# ----------------------------------
# pipeware audio
# ----------------------------------

sudo pacman -S \
    pipewire pipewire-audio pipewire-pulse pipewire-alsa pipewire-jack wireplumber

systemctl --user enable --now pipewire.socket
systemctl --user enable --now pipewire-pulse.socket
systemctl --user enable --now wireplumber.service

pactl info
