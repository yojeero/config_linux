# https://gist.github.com/Krieger1975/f2f9fd3e99910ecde7c60bd5e78132e7

# user in sudoers

su -

control sudowheel enabled

exit

su -

apt-get update

apt-get dist-upgrade

update-kernel

apt-get clean

remove-old-kernels

epm update && epm full-upgrade

# epm / apt-get install eepm

epm play имя программы

epm play --list

epm play --update имя программы

epm play --update all

apt-get install flatpak

apt-get install flatpak-repo-flathub

# FISH
epm -i fish
su -
usermod yopy -s /usr/bin/fish

# Установка тем

fish

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

fisher install jorgebucaran/nvm.fish

fisher install IlanCosman/tide@v5

# убрать приветствие

set -U fish_greeting

# cursor
epmi x-cursor-themes-Bibata

# bitwarden
epm play bitwarden

# ----------------------------------
# SPECTRWM 
# ----------------------------------

apt-get install spectrwm alacritty rofi picom feh maim slop xclip dunst xsecurelock

chmod +x ~/.config/spectrwm/bar_action.sh
chmod +x ~/.config/spectrwm/.spectrwm.conf

apt-get install xinitrc

mkdir -p /usr/share/xsessions

nano /usr/share/xsessions/spectrwm-custom.desktop

[Desktop Entry]
Name=Spectrwm (Custom)
Comment=Пользовательская сессия Spectrwm через .xinitrc
Exec=xinitrc
Type=Application
DesktopNames=spectrwm

# .xinitrc

chmod +x ~/.xinitrc



