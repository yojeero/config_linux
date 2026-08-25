
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
# arch + bspwm 
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

# -------------------------------
# LightDM remove
# -------------------------------

sudo systemctl disable lightdm.service
sudo pacman -R lightdm lightdm-gtk-greeter

#  Создайте и настройте файл .xinitrc

cp /etc/X11/xinit/xinitrc ~/.xinitrc

nano ~/.xinitrc

# Прокрутите файл в самый низ. Удалите или закомментируйте стандартные строки запуска с twm &, xclock & и заканчиваются на exec xterm....

#  В самом конце файла добавьте строки для запуска sxhkd + bspwm

sxhkd &
exec bspwm

sudo chown -R yopy:yopy ~/.xinitrc ~/.Xauthority

# Чтобы настроить автоматический запуск bspwm сразу после ввода логина и пароля в tty (минуя ручной ввод startx), вам нужно добавить специальное условие в конфигурационный файл оболочки fish

nano ~/.config/fish/config.fish

# Добавьте в конец файла 
# Автозапуск X11 при логине в tty1

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
