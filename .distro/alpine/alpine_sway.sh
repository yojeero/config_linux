# Alpine Linux + Sway

## TTY Login → автоматический запуск Sway

Цель:

* Alpine Linux `latest-stable`
* обычный `sys` installation
* OpenRC
* без GDM/SDDM/LightDM
* вход через TTY
* автоматический запуск Sway на `tty1`
* `seatd`
* PipeWire + WirePlumber
* Firefox
* Waybar
* Fuzzel
* Foot
* Thunar
* XDG portals
* нормальная работа Wayland

---

# Установка Alpine

root

setup-alpine

Keyboard layout: us
Keyboard variant: us
Hostname: alpine
Network: dhcp

https://dl-cdn.alpinelinux.org/alpine/

sda

sys

reboot


После перезагрузки войти как `root`.

# Репозитории

cat /etc/apk/repositories

https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community

apk update
apk upgrade

# Базовые инструменты

apk add nano vim git curl wget sudo

# Создать пользователя

# adduser USERNAME
adduser yopy

apk add sudo

nano /etc/sudoers

root ALL=(ALL:ALL) ALL
%sudo ALL=(ALL:ALL) ALL

# addgroup USERNAME sudo
addgroup yopy sudo

# groups USERNAME
groups yopy

# Базовые системные программы

apk add \
    dbus \
    elogind \
    gvfs \
    udisks2 \
    ntfs-3g \
    polkit-elogind

# Seat management

# Sway нужен механизм доступа к DRM/input устройствам.

apk add seatd

rc-update add seatd default
rc-service seatd start

# addgroup USERNAME seat
addgroup yojee seat

# groups USERNAME
groups yopy

# Должно быть примерно:
USERNAME ... seat sudo

# Sway
apk add \
    sway \
    swaybg \
    swaylock \
    swayidle \
    foot \
    waybar \
    fuzzel \
    wl-clipboard \
    grim \
    slurp

# XWayland
apk add xwayland

# XDG Desktop Portal
apk add \
    xdg-desktop-portal \
    xdg-desktop-portal-wlr

# PipeWire
apk add \
    pipewire \
    pipewire-pulse \
    wireplumber \
    pavucontrol

apk info | grep -E 'pipewire|wireplumber'

# Настройка PipeWire

# PipeWire в современном Alpine запускается как **user service**, а не как обычный системный daemon.
rc-service -U pipewire status

rc-service -U pipewire start
rc-service -U wireplumber start
rc-service -U pipewire-pulse start

# Если все запускается нормально, включить user services:
rc-update -U add pipewire gui
rc-update -U add wireplumber gui
rc-update -U add pipewire-pulse gui

# Проверить:
rc-service -U pipewire status
rc-service -U wireplumber status
rc-service -U pipewire-pulse status

# PipeWire и WirePlumber сейчас рекомендуется настраивать именно через OpenRC user services.

# Важный момент с D-Bus
rc-update add dbus default
rc-service dbus start

dbus-run-session sway

# Это дает отдельную D-Bus session для графической сессии.

# Базовые графические программы
apk add \
    firefox \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    file-roller \
    tumbler \
    mousepad \
    imv \
    mpv \
    pavucontrol

# Архивы и файловые инструменты
apk add \
    p7zip \
    unzip \
    zip \
    file

# CLI-инструменты
apk add \
    bottom \
    fastfetch \
    mc \
    ripgrep \
    fd \
    fzf \
    eza

# Дополнительные программы
apk add \
    vim \
    curl \
    wget \
    git

# Иконки
apk add papirus-icon-theme

# Power management
apk add xfce4-power-manager

exec xfce4-power-manager

# Группы пользователя

# addgroup USERNAME audio
addgroup yopy audio

# addgroup USERNAME seat
addgroup yopy seat

# Первый запуск Sway вручную

# Перед автоматическим запуском лучше сначала проверить Sway вручную.

# Переключиться на пользователя:
# su - USERNAME
su - yopy

dbus-run-session sway

# Если Sway стартует — отлично.

# Выйти из Sway
Super + Shift + E

# Если Sway не запускается, **не делай пока автозапуск**. Сначала исправь проблему.

# Автоматический запуск Sway с tty1

# После того как ручной запуск работает

# nano /home/USERNAME/profile
nano /home/yopy/.profile

if [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session sway
fi

# Почему не использовать `$DISPLAY`

# Лучше проверять непосредственно tty
if [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session sway
fi

# Таким образом Sway запускается только при входе на
tty1

# Перезагрузка

exit

reboot

# После загрузки появится:

alpine login

USERNAME
и пароль.

# После входа `.profile` автоматически выполнит и запустится Sway

dbus-run-session sway

# Если нужно выйти из Sway
Super + Shift + E

# После выхода должен появиться обычный TTY.

# Можно снова запустить:
dbus-run-session sway

# Проверка PipeWire

# Внутри Sway открыть терминал:
Super + Enter

wpctl status

# Должны отображаться:

Audio
 ├─ Devices
 ├─ Sinks
 └─ Sources

pactl info

# Если PipeWire PulseAudio compatibility работает, будет видно PipeWire.

# Проверка Wayland

# В терминале:
echo $XDG_SESSION_TYPE

# Ожидаемый результат
wayland

# Проверить
echo $WAYLAND_DISPLAY

# Например
wayland-1

# Проверка seatd
rc-service seatd status

# Должно быть:
status: started

# Проверить пользователя
groups

# В списке должна быть
seat

# Проверка Firefox
firefox

# Если Firefox работает нормально — базовая Wayland-система готова.

# Проверить в Firefox
about:support

# и посмотреть Window Protocol.
wayland

# Конфигурация Sway
~/.config/sway/config

# Создать каталог:
mkdir -p ~/.config/sway

# Если соственного конфига еще нет, можно скопировать системный:
cp /etc/sway/config ~/.config/sway/config

nano ~/.config/sway/config

# Screenshot

# Для скриншота всего экрана
bindsym Print exec grim ~/Pictures/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png

# Waybar
waybar

# Конфигурация
~/.config/waybar/

# Создать
mkdir -p ~/.config/waybar

# Полезные команды после установки
sudo apk update
sudo apk upgrade

apk search PACKAGE
apk info PACKAGE

sudo apk del PACKAGE

# Список установленных пакетов
apk info

# Если Sway не стартует после перезагрузки

# Переключиться на другой TTY
Ctrl + Alt + F2

# Войти пользователем.

# Запустить вручную
dbus-run-session sway

# Посмотреть ошибки
sway -d 2> ~/sway.log

# После этого
less ~/sway.log

# Если проблема в `.profile`, временно переименовать его:
mv ~/.profile ~/.profile.backup

# После этого можно войти в TTY без автоматического запуска Sway.


# Если хочется полностью ручной режим

# Можно вообще не использовать `.profile`.
alpine login:

dbus-run-session sway

# Это самый простой и надежный вариант для первоначальной настройки.

# Автозапуск лучше включать только после того, как Sway стабильно запускается вручную.

# Финальный набор пакетов
apk add \
    sway \
    swaybg \
    swaylock \
    swayidle \
    foot \
    waybar \
    fuzzel \
    wl-clipboard \
    grim \
    slurp \
    xwayland \
    seatd \
    dbus \
    xdg-desktop-portal \
    xdg-desktop-portal-wlr \
    pipewire \
    pipewire-pulse \
    wireplumber \
    pavucontrol \
    firefox

# Файловый менеджер
apk add \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    gvfs \
    udisks2 \
    ntfs-3g \
    tumbler \
    file-roller

# Утилиты
apk add \
    fastfetch \
    bottom \
    mc \
    eza \
    fd \
    fzf \
    ripgrep \
    fzf \
    curl \
    wget \
    git \
    vim \
    nano

# Мультимедиа
apk add \
    mpv \
    imv

# Ноутбук
apk add \
    xfce4-power-manager

# Включение системных сервисов

# После установки
rc-update add dbus default
rc-update add seatd default

rc-service dbus start
rc-service seatd start

# PipeWire не добавлять как обычный `default` service — это пользовательские сервисы.

# Финальная проверка

# Перед перезагрузкой
rc-service dbus status
rc-service seatd status

# Войти пользователем
su - USERNAME
groups

# Должны присутствовать
sudo
seat
audio

# Проверить Sway
dbus-run-session sway

# После запуска проверить
echo $XDG_SESSION_TYPE

# Должно быть
wayland

# Проверить звук
wpctl status

# Проверить Firefox:
firefox

# И только после этого сделать
reboot

# После входа в `tty1` должен автоматически запускаться Sway.

---

# Итоговая схема

```text
BIOS/UEFI
    ↓
Alpine Linux
    ↓
OpenRC
    ↓
TTY1
    ↓
login USERNAME
    ↓
~/.profile
    ↓
dbus-run-session sway
    ↓
Sway
    ├── Waybar
    ├── Fuzzel
    ├── Foot
    ├── Firefox
    ├── Thunar
    ├── PipeWire
    ├── WirePlumber
    └── XWayland
