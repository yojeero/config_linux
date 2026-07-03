# ----------------------------------
# Bios Legacy + MBR
# ----------------------------------

# --------------------------------------------
# DISK PARTITIONING
# --------------------------------------------

sudo su

sgdisk --zap-all /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M count=10

# 1. Disk partition (MBR, 1GB vfat boot, 50GB root/data)
fdisk /dev/sda <<EOF
o
n
p
1

+1G
a
n
p
2

+50G
w
EOF

# 2. Updating the partition table in the system
partprobe /dev/sda

# 3. Formatting partitions in ext4
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

lsblk

# --------------------------------------------
# FILESYSTEMS
# --------------------------------------------

mkdir -p /mnt
mount /dev/sda2 /mnt

mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# disk info
sudo fdisk -l /dev/sda

# ==================================

# update
sudo pacman -Syuu

# yay
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S \
        firefox kitty alacritty mousepad\
        thunar thunar-archive-plugin thunar-volman \
        bottom fastfetch yazi mc file-roller \
        p7zip unzip zip ouch \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib2 ripgrep zoxide \
        celluloid rhythmbox imagemagick ffmpeg \
	lxappearance gtk-engine-murrine palette \
        ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-terminus-nerd

yay -S google-chrome visual-studio-code-bin

# SHELL
sudo pacman -Sy fish eza fzf fd

chsh -s $(command -v fish)

# ----------------------------------
# xfce
# ----------------------------------
sudo pacman -S xfce4-goodies network-manager-applet pavucontrol

# ----------------------------------
# BSPWM
# ----------------------------------
sudo pacman -S bspwm sxhkd rofi picom polybar feh dunst maim slop xclip

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh

# ----------------------------------
# sway
# ----------------------------------
yay -S \
    sway swaybg swaylock swayidle swaylock-effects \
    foot waybar fuzzel \
    wl-clipboard grim slurp \
    mako xdg-desktop-portal-gtk

# ----------------------------------
# spectrwm 
# ----------------------------------
sudo pacman -S spectrwm alacritty rofi maim slop xclip feh picom dunst i3lock

sudo sensors-detect
