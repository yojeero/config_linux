
# =========================================
# Base Alpine installing
# =========================================

# вход в командную оболочку
root

setup-alpine

# выбираем раскладку
us

us

# имя компьютера
alpine-laptop

# настройка сети
пропускаем Enter 

# пароль пользователя / Если он 6-значный, получите предупреждение , но это не мешает установке.
1231231

# настройка прокси
пропускаем Enter
 
# зеркала репозиториев
http://mirror.ungleich.ch/mirror/packages/alpine/

# настройка SSH
пропускаем Enter 

# место установки
sda

# выбрать для чего будет использоваться диск / системный диск
sys

# запрос на стирание диска
y

reboot

# enter like root / not user -------------------------
root

pass

# установка nano
apk add nano

# редактирование файла с репозиториями и обновление
nano /etc/apk/repositories

# чтобы получить доступ к репозиторию сообщества надо раскомментиовать третью строку:
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing

# удалите # перед ней. После жмем ctrl+o -> Enter -> ctrl+x.
apk update

# установка sudo
apk add sudo
nano /etc/sudoers

root	ALL=(ALL:ALL) ALL
%sudo	ALL=(ALL:ALL) ALL
yopy	ALL=(ALL:ALL) ALL

# установка графического интерфейса
setup-xorg-base

# ===========================================
#  xfce install
# ===========================================
apk add xfce4 xf86-video-fbdev xf86-video-vesa  \ 
        font-terminus firefox xfce4-terminal xfce4-screensaver \ 
        lightdm-gtk-greeter mousepad thunar thunar-volman thunar-archive-plugin \ 
        p7zip 7zip unzip tar gzip xarchiver gvfs udisks2 ntfs-3g wget git \ 
        celluloid rhythmbox

# dm
setup-devd udev

rc-service lightdm start
sudo rc-update add lightdm default

# из графической среды мы не можем выключить, перезагрузить или отправить в ждущий режим ноутбук
sudo apk add elogind polkit-elogind

sudo reboot

# настроим повышение привилегий для утилит с графическим интерфейсом
sudo rc-update add elogind default
sudo rc-service elogind start
sudo rc-service dbus start
sudo rc-update add dbus

# обычно использую pulseaudio, но разработчики настойчиво рекомендуют pipewire
sudo addgroup apem audio
sudo addgroup apem video

sudo apk add pipewire wireplumber pipewire-pulseaudio \ 
                pavucontrol xfce4-pulseaudio-plugin

sudo reboot

startx

# =========================================
# LightDM to tty
# =========================================
sudo systemctl disable lightdm
sudo systemctl set-default multi-user.target
sudo systemctl enable getty@tty1.service

# in /etc/default/grub input
nomodesetв GRUB_CMDLINE_LINUX_DEFAULT 

# перегенерировать с помощью 
grub-mkconfig -o /boot/grub/grub.cfg

# ===========================================
# vscode / zed / librewolf  
# ===========================================
apk add gcompat libuser bash
apk add code-oss zed librewolf
