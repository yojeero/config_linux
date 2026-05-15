# ----------------------------------
# Bios Legacy + MBR
# ----------------------------------

lsblk

cfdisk /dev/sda

1G	vfat boot	     /boot 
50G	ext4 Linux root   / 

# format
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# mount
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# disk info
sudo fdisk -l /dev/sda

# ==================================

# update 
sudo pacman -Syuu

# pkgs
sudo pacman -Sy \
        firefox kitty ghostty \
        nautilus file-roller yazi \
        mousepad fastfetch bottom \
        zip unzip p7zip unrar ouch \
        wget git curl gvfs udisks2 ntfs-3g \
        xdg-utils glib ripgrep zoxide \
        celluloid rhythmbox imagemagick ffmpeg \
        adwaita-icon-theme mint-y-icons

# SHELL
sudo pacman -Sy fish eza fzf fd

chsh -s $(command -v fish) 

# chrome vscode
sudo pacman -Sy google-chrome visual-studio-code-bin 

# ----------------------------------
# Gnome extensions
# ----------------------------------

Dash in Panel
User Themes
Auto Move Windows
Light Style
Removable Drive Menu
Screenshot Window Sizer
Blur my Shell

# ----------------------------------
# XFCE error
# ----------------------------------

# Open a terminal Ctrl+Alt+T or via TTY
xfce4-panel -r
xfdesktop --reload

# Reset xfdesktop settings (desktop is gone)
xfconf-query -c xfce4-desktop -R -r
xfdesktop &

# This will remove all XFCE settings (panel, themes, hotkeys)
mv ~/.config/xfce4 ~/.config/xfce4.backup

xfce4-session-logout

# If the panel is missing
rm -rf ~/.config/xfce4/panel
xfce4-panel &

# Sometimes the problem is broken themes
sudo pacman -S adwaita-icon-theme

# If the screen is completely blank, restart XFCE
startxfce4

# or
xfdesktop &
xfce4-panel &