# =========================
# GNOME на Void Linux + dinit
# Минимальная и оптимизированная установка
# =========================

# Обновление системы
sudo xbps-install -Su

# -------------------------------------------------
# Установка Dinit
# -------------------------------------------------

sudo xbps-install -S dinit dinit-services

# Если переходите с runit:
sudo xbps-remove -R runit-void

# -------------------------------------------------
# Базовый GNOME без мусора
# -------------------------------------------------

sudo xbps-install -S \
gnome-shell \
gnome-session \
gnome-control-center \
gnome-settings-daemon \
mutter \
gvfs \
nautilus \
gdm \
file-roller \
gnome-shell-extensions \
gnome-screenshot \
gnome-tweaks \
dbus \
polkit

# -------------------------------------------------
# Включение сервисов Dinit
# -------------------------------------------------

sudo ln -s /etc/dinit.d/dbus /etc/dinit.d/boot.d/
sudo ln -s /etc/dinit.d/polkitd /etc/dinit.d/boot.d/
sudo ln -s /etc/dinit.d/gdm /etc/dinit.d/boot.d/

# NetworkManager
sudo xbps-install -S NetworkManager
sudo ln -s /etc/dinit.d/NetworkManager /etc/dinit.d/boot.d/

# Проверка сервисов
dinitctl list

# Запуск вручную
sudo dinitctl start gdm
sudo dinitctl start NetworkManager

# -------------------------------------------------
# Удаление ненужного GNOME софта
# -------------------------------------------------

sudo xbps-remove -R \
epiphany \
gnome-boxes \
gnome-calculator \
gnome-calendar \
gnome-contacts \
gnome-maps \
gnome-music \
gnome-weather \
gnome-clocks \
gnome-photos \
gnome-software \
totem \
yelp \
simple-scan \
eog \
orca \
vino \
rygel \
gnome-logs \
gnome-remote-desktop \
malcontent

# -------------------------------------------------
# Отключение ненужных служб GNOME
# -------------------------------------------------

mkdir -p ~/.config/autostart

for svc in \
org.gnome.SettingsDaemon.Wacom.desktop \
org.gnome.SettingsDaemon.PrintNotifications.desktop \
org.gnome.SettingsDaemon.Color.desktop \
org.gnome.SettingsDaemon.A11ySettings.desktop \
org.gnome.SettingsDaemon.UsbProtection.desktop \
org.gnome.SettingsDaemon.Sharing.desktop \
org.gnome.SettingsDaemon.Smartcard.desktop \
org.gnome.SettingsDaemon.Housekeeping.desktop \
org.gnome.SettingsDaemon.Power.desktop
do
cp /etc/xdg/autostart/$svc ~/.config/autostart/ 2>/dev/null
echo "Hidden=true" >> ~/.config/autostart/$svc
done

# -------------------------------------------------
# Tracker и индексаторы
# -------------------------------------------------

# Полностью удалить индексатор:
sudo xbps-remove -R tracker tracker-miners

# -------------------------------------------------
# Оптимизация GNOME
# -------------------------------------------------

# Отключить анимации
gsettings set org.gnome.desktop.interface enable-animations false

# Уменьшить timeout Mutter
gsettings set org.gnome.mutter check-alive-timeout 0

# Отключить hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Отключить автоблокировку
gsettings set org.gnome.desktop.session idle-delay 0

# Отключить suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# -------------------------------------------------
# PipeWire (рекомендуется)
# -------------------------------------------------

sudo xbps-install -S \
pipewire \
wireplumber \
alsa-pipewire

# Dinit сервисы PipeWire
sudo ln -s /etc/dinit.d/pipewire /etc/dinit.d/user/
sudo ln -s /etc/dinit.d/wireplumber /etc/dinit.d/user/

# -------------------------------------------------
# Wayland / X11
# -------------------------------------------------

# Wayland рекомендуется
# Для NVIDIA:
sudo xbps-install -S nvidia

# Для X11:
sudo xbps-install -S xorg

# -------------------------------------------------
# Компиляция пакетов под железо
# -------------------------------------------------

mkdir -p ~/.config

cat > ~/.config/xbps-src.conf << EOF
XBPS_MAKEJOBS=$(nproc)
XBPS_CFLAGS="-march=native -mtune=native -O2 -pipe"
XBPS_CXXFLAGS="\$XBPS_CFLAGS"
XBPS_RUSTFLAGS="-C opt-level=3"
EOF

# Инструменты сборки
sudo xbps-install -S \
base-devel \
git \
curl \
ccache

# -------------------------------------------------
# Сборка GNOME компонентов через xbps-src
# -------------------------------------------------

git clone https://github.com/void-linux/void-packages.git
cd void-packages

./xbps-src binary-bootstrap

# Пересборка mutter
./xbps-src pkg mutter

# Пересборка gnome-shell
./xbps-src pkg gnome-shell

# Установка собранных пакетов
sudo xbps-install --repository hostdir/binpkgs gnome-shell mutter

# -------------------------------------------------
# Дополнительные lightweight замены
# -------------------------------------------------

# Вместо Nautilus:
sudo xbps-install -S thunar

# Вместо File Roller:
sudo xbps-install -S xarchiver

# Лёгкий просмотрщик изображений:
sudo xbps-install -S nsxiv

# -------------------------------------------------
# Полезные проверки
# -------------------------------------------------

# Проверка Wayland
echo $XDG_SESSION_TYPE

# Проверка GNOME Shell
gnome-shell --version

# Проверка Dinit
dinitctl --version

# -------------------------------------------------
# Итог
# -------------------------------------------------

# После оптимизации GNOME + Dinit:
# - RAM после логина ~800-1100 МБ
# - меньше фоновых процессов
# - быстрее запуск GNOME Shell
# - меньше CPU wakeups
# - плавный Wayland
# - быстрый cold boot
# - современный GTK4 стек

# Dinit обычно:
# - быстрее systemd/runit на старте
# - проще по архитектуре
# - меньше overhead
# - легче дебажится