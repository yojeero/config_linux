
# Gentoo Linux

# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
curl -fsSL https://install.danklinux.com | sh

# Two community overlays provide for Gentoo
quilat-overlay​

# The quilat-overlay provides a live ebuild (gui-shell/dms-9999) with OpenRC and systemd support. 
sudo eselect repository add quilat-overlay git https://github.com/Graght/quilat-overlay.git
sudo emaint sync -r quilat-overlay

# Or manually in /etc/portage/repos.conf/quilat-overlay.conf:

[quilat-overlay]
location = /var/db/repos/quilat-overlay
sync-type = git
sync-uri = https://github.com/Graght/quilat-overlay.git
Then sync and install:

sudo emaint sync -r quilat-overlay

# With systemd
sudo emerge --ask gui-shell/dms

# With OpenRC (elogind)
sudo USE="-systemd" emerge --ask gui-shell/dms
tdgentoo​

# The tdgentoo overlay provides a versioned ebuild (gui-wm/DankMaterialShell) pinned to stable releases.
sudo eselect repository add tdgentoo git https://github.com/timdodge/tdgentoo.git
sudo emaint sync -r tdgentoo

# Or manually in /etc/portage/repos.conf/tdgentoo.conf:

[tdgentoo]
location = /var/db/repos/tdgentoo
sync-type = git
sync-uri = https://github.com/timdodge/tdgentoo.git

# Then sync and install:

sudo emaint sync -r tdgentoo
sudo emerge --ask gui-wm/DankMaterialShell
dacyberduck overlay​

# The dacyberduck overlay provides DMS under dank-base/dankmaterialshell.

sudo eselect repository add dacyberduck git https://codeberg.org/dacyberduck/gentoo-overlay.git
sudo emaint sync -r dacyberduck

# Or manually in /etc/portage/repos.conf/dacyberduck.conf:

[dacyberduck]
location = /var/db/repos/dacyberduck
sync-type = git
sync-uri = https://codeberg.org/dacyberduck/gentoo-overlay.git

# Then sync and install
sudo emaint sync -r dacyberduck
sudo emerge --ask dank-base/dankmaterialshell

