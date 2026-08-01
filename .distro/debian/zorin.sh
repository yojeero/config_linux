
# ----------------------------------
# удалить Snap из Zorin
# ----------------------------------

# Удаление установленных Snap-пакетов
snap list

sudo snap remove --purge PKG

sudo snap remove --purge core20
sudo snap remove --purge core22
sudo snap remove --purge bare
sudo snap remove --purge snapd

# Удаление службы snapd
sudo apt purge snapd

sudo rm -rf /var/cache/snapd/
sudo rm -rf ~/snap

# Блокировка повторной установки (Запрет Snap)
sudo nano /etc/apt/preferences.d/nosnap.pref

Package: snapd
Pin: release a=*
Pin-Priority: -10

sudo apt update

