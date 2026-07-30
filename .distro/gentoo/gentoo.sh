
# ----------------------------------
# spectrwm v.3.7.0
# ----------------------------------

``` sh
git clone https://github.com/Y-Forks/spectrwm
cd spectrwm/linux
make
make install
```

## Pkgs

``` sh
emerge --ask \
x11-terms/alacritty \
x11-misc/rofi \
x11-misc/picom \
media-gfx/feh \
x11-misc/dunst \
x11-misc/xclip \
media-gfx/maim \
x11-misc/slop \
x11-apps/xsetroot \
www-client/firefox \
xfce-base/thunar \
xfce-extra/thunar-archive-plugin \
xfce-base/thunar-volman \
app-editors/mousepad \
app-misc/fastfetch \
app-misc/mc \
sys-process/bottom \
media-video/celluloid \
media-gfx/imagemagick \
media-video/ffmpeg \
media-gfx/imv
```

## 17. i3lock-color

``` sh
echo "x11-misc/i3lock-color ~amd64" \
>/etc/portage/package.accept_keywords/i3lock-color

emerge --ask x11-misc/i3lock-color
```

# ----------------------------------
# sway
# ----------------------------------

git clone https://github.com/Y-Forks/sway
cd spectrwm
make
sudo make install

emerge --ask --getbinpkg \
    gui-apps/swaybg gui-apps/swayidle gui-apps/swaylock gui-apps/swaylock-effects \
    gui-apps/foot gui-apps/waybar gui-apps/fuzzel gui-apps/mako \
    gui-apps/grim gui-apps/slurp x11-misc/wl-clipboard \
    sys-apps/xdg-desktop-portal-gtk

# ----------------------------------
# pkgs
# ----------------------------------
emerge --ask --getbinpkg www-client/firefox x11-terms/kitty app-editors/mousepad
emerge --ask --getbinpkg xfce-base/thunar xfce-extra/thunar-archive-plugin xfce-base/thunar-volman
emerge --ask --getbinpkg sys-process/bottom app-misc/fastfetch app-misc/mc app-arch/file-roller
emerge --ask --getbinpkg app-arch/7zip app-arch/unzip app-arch/zip app-arch/ouch
emerge --ask --getbinpkg net-misc/wget dev-vcs/git net-misc/curl gnome-base/gvfs sys-fs/udisks sys-fs/ntfs3g
emerge --ask --getbinpkg dev-libs/glib sys-apps/ripgrep 
emerge --ask --getbinpkg sys-apps/zoxide xfce-extra/xfce4-screenshooter
emerge --ask --getbinpkg media-video/celluloid media-sound/rhythmbox
emerge --ask --getbinpkg media-gfx/imagemagick media-video/ffmpeg media-gfx/imv
emerge --ask --getbinpkg x11-misc/lxappearance x11-apps/xsetroot

# ----------------------------------
# bspwm
# ----------------------------------

emerge --ask --getbinpkg \
    x11-wm/bspwm x11-misc/sxhkd x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar \
    media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# ----------------------------------
# SHELL
# ----------------------------------
emerge --ask --getbinpkg \
    app-shells/fish sys-apps/eza app-shells/fzf sys-apps/fd

chsh -s $(which fish)

# ----------------------------------
# vscode chrome
# ----------------------------------

# license
mkdir -p /etc/portage/package.license

cat > /etc/portage/package.license/custom <<EOF
www-client/google-chrome google-chrome
app-editors/vscode MIT Microsoft-vscode
EOF

emerge --ask --getbinpkg www-client/google-chrome app-editors/vscode

# ----------------------------------
# github config
# ----------------------------------
emerge --ask dev-vcs/git

git clone https://github.com/yojeero/config_linux.git ~/Dots

git clone https://github.com/yojeero/bspwm_cobalt.git ~/Dots

# ----------------------------------
# Если вы хотите увидеть, с какими именно флагами прилетят готовые бинарники
# ----------------------------------
emerge -pvg xfce-base/tumbler x11-libs/gdk-pixbuf

# ----------------------------------
# Keyboard
# ----------------------------------

``` sh
mkdir -p /etc/X11/xorg.conf.d

cat >/etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "us,ru"
    Option "XkbOptions" "grp:alt_shift_toggle"
EndSection
EOF
```

# keyboard swith

``` sh
git clone https://github.com/Y-Forks/xkb-switch
cd xkb-switch
mkdir build && cd build
cmake ..
make
sudo make install
sudo ldconfig
```

# ----------------------------------
# yazi
# ----------------------------------
# Run these commands in a terminal to install automatic archive preview and code/syntax highlighting plugins

# Plugin for previewing the contents of archives (zip, tar, rar, etc.)
ya pack -a yazi-rs/plugins:ouch

# Plugin for beautiful code syntax highlighting
ya pack -a yazi-rs/plugins:code-glow
