# ----------------------------------
# https://danklinux.com/
# ----------------------------------
curl -fsSL https://install.danklinux.com | sh

sudo emerge --ask sys-apps/accountsservice

# ==================================

# ----------------------------------
# guru (Recommended) official overlay
# ----------------------------------

sudo eselect repository enable guru
sudo emaint sync -r guru
sudo emerge --ask gui-apps/dankmaterialshell

echo "gui-apps/dankmaterialshell ~amd64" | sudo tee -a /etc/portage/package.accept_keywords/dankmaterialshell

# ----------------------------------
# Alternative Overlays tdgentoo
# ----------------------------------
sudo eselect repository add tdgentoo git https://github.com/timdodge/tdgentoo.git
sudo emaint sync -r tdgentoo
sudo emerge --ask gui-wm/DankMaterialShell

# ----------------------------------
# Alternative Overlays dacyberduck
# ----------------------------------
sudo eselect repository add dacyberduck git https://codeberg.org/dacyberduck/gentoo-overlay.git
sudo emaint sync -r dacyberduck
sudo emerge --ask dank-base/dankmaterialshell


