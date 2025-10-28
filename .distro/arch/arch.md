
# ================================
# arch installing
# ================================

# update 
sudo pacman -Syuu

# fonts
sudo fc-cache -f -v

# install yay -----------------
sudo pacman -Syy
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version

# refresh the system packages and upgrade
yay -Syu

# packagers --------------------
yay -S thunar thunar-archive-plugin thunar-volman mousepad \ 
        kitty foot firefox fish fastfetch \ 
        wget git gparted gnome-system-monitor btop gvfs udisks2 ntfs-3g \ 
        neovim yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick \ 
        feh cava dunst eww imv scrot grim slurp celluloid rhythmbox \ 
        qt6ct qt5ct qt5-wayland qt6-wayland blueman brightnessctl networkmanager 
        
yay -S lxappearance gtk-murrine-engine gtk2-engine-murrine

# exec grim -g "$(slurp)" $(date +'%F_%T.png')

# set fish to shell
chsh -s `which fish`

# packagers remove -------------
# wps office arch
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si

sudo systemctl enable --now snapd.socket

sudo ln -s /var/lib/snapd/snap /snap

# list installed packagers
pacman -Qe

# list packages to list
pacman -Qqe > package_list.txt
