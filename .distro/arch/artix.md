Artix dinit

init: dinit
WM: sway (или i3)
звук: PipeWire
сеть: NetworkManager
логин: greetd

# пошаговая установка Artix + dinit + sway

# посмотреть диск
lsblk

# разметка диска
cfdisk /dev/sda

EFI: 512M FAT32
root: остальное ext4

# форматирование
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# монтирование
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# установка базы dinit + elogind
basestrap /mnt base base-devel linux linux-firmware dinit elogind-dinit mkinitcpio nano

# fstab
fstabgen -U /mnt >> /mnt/etc/fstab

# chroot
artix-chroot /mnt
mkinitcpio -P

# базовая настройка
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# локали

nano /etc/locale.gen

# раскомментируй
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# hostname
echo "artix" > /etc/hostname
nano /etc/hosts

# добавь
127.0.0.1 localhost
::1       localhost
127.0.1.1 artix.localdomain artix

# root пароль
passwd

# пользователь
useradd -m -G wheel,audio,video,input,storage youruser
passwd youruser

# sudo
pacman -S sudo
EDITOR=nano visudo

# раскомментируй
%wheel ALL=(ALL) ALL

# установка загрузчика (GRUB, UEFI)
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# сервисы dinit
pacman -S dbus-dinit networkmanager-dinit greetd-dinit

# добавляем в автозапуск
ln -s /etc/dinit.d/dbus /etc/dinit.d/boot.d/
ln -s /etc/dinit.d/NetworkManager /etc/dinit.d/boot.d/
ln -s /etc/dinit.d/greetd /etc/dinit.d/boot.d/

# графика + sway
pacman -S sway swaybg swayidle swaylock waybar foot wl-clipboard xdg-desktop-portal-wlr

# логин greetd
pacman -S seatd seatd-dinit
ln -s /etc/dinit.d/seatd /etc/dinit.d/boot.d/

# установим greeter
pacman -S greetd-tuigreet

# конфиг
nano /etc/greetd/config.toml
useradd -M -s /usr/bin/nologin greeter

# пример
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd 'dbus-run-session sway'"
user = "greeter"

# звук
pacman -S pipewire wireplumber pipewire-alsa pipewire-pulse

exec pipewire
exec wireplumber

# сеть
pacman -S networkmanager networkmanager-dinit network-manager-applet nm-connection-editor

# microcode
pacman -S intel-ucode   # Intel
pacman -S amd-ucode     # AMD

# файловый менеджер
pacman -S thunar thunar-archive-plugin thunar-volman foot fish fastfetch gnome-text-editor
pacman -S wget git gparted btop gvfs udisks2 ntfs-3g gvfs-mtp gvfs-smb
pacman -S neovim ffmpeg 7zip jq poppler fd fzf imagemagick ripgrep
pacman -S feh cava imv scrot grim slurp celluloid rhythmbox mako
pacman -S qt6ct qt5ct qt5-wayland qt6-wayland
pacman -S ttf-liberation noto-fonts ttf-jetbrains-mono noto-fonts-emoji

pacman -S xdg-user-dirs
xdg-user-dirs-update

pacman -S bluez bluez-utils
ln -s /etc/dinit.d/bluetooth /etc/dinit.d/boot.d/

# frontend
pacman -S nodejs npm fnm code google-chrome lazygit github-cli docker docker-compose

# Wayland + Chrome иначе будет лагать
google-chrome-stable --ozone-platform=wayland

# nano ~/.config/fish/config.fish или .bashrc
fnm env | source
fnm install --lts
fnm default lts-latest

# drivers
pacman -S polkit polkit-gnome

pacman -S mesa vulkan-intel   # Intel
# pacman -S mesa vulkan-radeon  # AMD
# pacman -S nvidia nvidia-utils # NVIDIA (сложнее)

# в sway
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# автозапуск в sway
mkdir -p ~/.config/sway
nano ~/.config/sway/config

# добавь
exec dbus-update-activation-environment --all
exec nm-applet
exec mako
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# перезагрузка
exit
umount -R /mnt
reboot

-------------------------------------------

# DEV
# File watcher fix для React/Vite
# Linux иногда упирается в лимиты
sudo nano /etc/sysctl.d/99-inotify.conf

# Добавь
fs.inotify.max_user_watches=524288
fs.inotify.max_user_instances=512

# Применить

sudo sysctl --system

# VSCode + Wayland чтобы не было blur/lag

# Запуск
code --enable-features=UseOzonePlatform --ozone-platform=wayland

npm install -g pnpm yarn bun

# env для dev (очень важно)
# Добавь в sway config
exec export MOZ_ENABLE_WAYLAND=1
exec export NPM_CONFIG_PREFIX="$HOME/.npm-global"
