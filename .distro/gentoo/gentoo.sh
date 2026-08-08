
# ----------------------------------
# Spectrwm 
# ---------------------------------- 

``` sh
emerge --ask \
x11-wm/spectrwm \
x11-terms/alacritty \
x11-misc/rofi \
x11-misc/picom \
media-gfx/feh \
app-misc/fastfetch \
x11-misc/dunst \
x11-misc/xclip \
media-gfx/maim \
x11-misc/slop \
x11-apps/xsetroot \
www-client/firefox \
xfce-base/thunar \
xfce-extra/thunar-archive-plugin \
xfce-base/thunar-volman \
xfce-base/tumbler \
app-editors/mousepad \
app-arch/file-roller \
gnome-base/gvfs \
sys-fs/udisks \
x11-libs/gdk-pixbuf \
app-editors/vim \
app-misc/mc \
sys-process/bottom \
media-video/celluloid \
media-gfx/imagemagick \
media-video/ffmpeg \
media-video/ffmpegthumbnailer \
media-gfx/imv \
x11-base/xorg-apps \
x11-misc/lxappearance \
media-fonts/noto
```

# nemo config
gsettings set org.nemo.desktop show-desktop-icons false
gsettings set org.cinnamon.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg '--working-directory'

# ----------------------------------
# bspwm
# ----------------------------------

emerge --ask --getbinpkg \
    x11-wm/bspwm x11-misc/sxhkd x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar \
    media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

# ----------------------------------
# SHELL
# ----------------------------------
emerge --ask --getbinpkg app-shells/fish sys-apps/eza app-shells/fzf sys-apps/fd

chsh -s $(which fish)

# ----------------------------------
# vscode chrome zed
# ----------------------------------

# license
mkdir -p /etc/portage/package.license

cat > /etc/portage/package.license/custom <<EOF
www-client/google-chrome google-chrome
app-editors/vscode MIT Microsoft-vscode
EOF

emerge --ask --getbinpkg www-client/google-chrome 
emerge --ask --getbinpkg app-editors/vscode 
emerge --ask --getbinpkg app-editors/zed 

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
