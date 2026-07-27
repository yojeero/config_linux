
# ----------------------------------
# spectrwm
# ----------------------------------
emerge --ask --getbinpkg x11-wm/spectrwm x11-terms/alacritty x11-misc/rofi x11-misc/picom x11-misc/polybar media-gfx/feh x11-misc/dunst media-gfx/maim x11-misc/slop x11-misc/xclip

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
emerge --ask --getbinpkg x11-misc/lxappearance x11-themes/kvantum x11-misc/qt6ct x11-apps/xsetroot

# ----------------------------------
# bspwm
# ----------------------------------
emerge --ask --getbinpkg x11-wm/bspwm x11-misc/sxhkd

# ----------------------------------
# SHELL
# ----------------------------------
emerge --ask --getbinpkg app-shells/fish sys-apps/eza app-shells/fzf sys-apps/fd
# run WITHOUT sudo to change yourself, not root
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