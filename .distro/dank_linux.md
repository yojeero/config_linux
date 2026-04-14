danklinux.com

Dank Linux

# Dependencies​
Quickshell (required) - The core framework
cava (optional) - Audio visualizer widget
cliphist + wl-clipboard (optional) - Clipboard history
dgop (optional) - System telemetry for resource widgets
dsearch (optional) - Filesystem search engine
matugen (optional) - Material Design color palette generation
niri (optional) - DMS Team's choice of Wayland compositor
qt6-multimedia (optional) - System sound feedback
For pre-built packages on Fedora, Debian, Ubuntu, and OpenSUSE, see the DankLinux Repository page.

# Arch & Derivatives​
sudo pacman -S dms-shell

# Fedora & CentOS​
sudo dnf copr enable avengemedia/dms
sudo dnf install dms

# Latest Development Build​
sudo dnf copr enable avengemedia/dms-git
sudo dnf install dms

# Debian & Ubuntu​
For Debian 13 (Trixie):

# DankLinux repository
curl -fsSL https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_13/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/danklinux.gpg
echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_13/ /" | \
  sudo tee /etc/apt/sources.list.d/danklinux.list

# DMS stable repository
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_13/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_13/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms.list

# DMS development repository
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/Debian_13/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms-git.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms-git.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/Debian_13/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms-git.list
sudo apt update
For Debian Testing:

# DankLinux repository
curl -fsSL https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_Testing/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/danklinux.gpg
echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_Testing/ /" | \
  sudo tee /etc/apt/sources.list.d/danklinux.list

# DMS stable repository
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_Testing/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_Testing/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms.list

# DMS development repository
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/Debian_Testing/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms-git.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms-git.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/Debian_Testing/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms-git.list
sudo apt update

# For Debian Sid

# DankLinux repository
curl -fsSL https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_Unstable/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/danklinux.gpg
echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_Unstable/ /" | \
  sudo tee /etc/apt/sources.list.d/danklinux.list

# DMS stable repository
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_Unstable/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_Unstable/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms.list

# DMS development repository
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/Debian_Unstable/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms-git.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms-git.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/Debian_Unstable/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms-git.list
sudo apt update

# Install Packages​

# Install the stable release:

sudo apt install dms

# Install the latest development build:

sudo apt install dms-git

# Ubuntu​

sudo add-apt-repository ppa:avengemedia/danklinux
sudo add-apt-repository ppa:avengemedia/dms
sudo apt update
sudo apt install dms

# Latest Development Build​

sudo add-apt-repository ppa:avengemedia/danklinux
sudo add-apt-repository ppa:avengemedia/dms-git
sudo apt update
sudo apt install dms-git

# tip

# Visit the DankLinux Repository page for OBS and PPA links and more information about available packages.

# Add niri or niri-git to your system to get the best experience.

# OpenSUSE & Derivatives​

OpenSUSE Tumbleweed​

# Stable Release​

# DankLinux repository

sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Tumbleweed/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/openSUSE_Tumbleweed/home:AvengeMedia:dms.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms
Latest Development Build​

# DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Tumbleweed/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/openSUSE_Tumbleweed/home:AvengeMedia:dms-git.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms-git

# OpenSUSE Leap 16​

# Stable Release​

# DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/16.0/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/16.0/home:AvengeMedia:dms.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms

Latest Development Build​

# DankLinux repository

sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/16.0/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/16.0/home:AvengeMedia:dms-git.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms-git

OpenSUSE Leap 16.1​

Stable Release​

# DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/16.1/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/16.1/home:AvengeMedia:dms.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms

Latest Development Build​

# DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/16.1/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/16.1/home:AvengeMedia:dms-git.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms-git

OpenSUSE Slowroll​

Stable Release​

# DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Slowroll/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/openSUSE_Slowroll/home:AvengeMedia:dms.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms

Latest Development Build​

# DankLinux repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Slowroll/home:AvengeMedia:danklinux.repo

# DMS repository
sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms-git/openSUSE_Slowroll/home:AvengeMedia:dms-git.repo
sudo zypper refresh

# Install DMS
sudo zypper install dms-git
Community Maintained

# Two community overlays provide DMS for Gentoo:

quilat-overlay​

# The quilat-overlay provides a live ebuild (gui-shell/dms-9999) with OpenRC and systemd support. This tracks git master, so updates come via emerge --sync && emerge -uDN @world.

sudo eselect repository add quilat-overlay git https://github.com/Graght/quilat-overlay.git
sudo emaint sync -r quilat-overlay

Or manually in /etc/portage/repos.conf/quilat-overlay.conf:

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

The tdgentoo overlay provides a versioned ebuild (gui-wm/DankMaterialShell) pinned to stable releases.

sudo eselect repository add tdgentoo git https://github.com/timdodge/tdgentoo.git
sudo emaint sync -r tdgentoo

Or manually in /etc/portage/repos.conf/tdgentoo.conf:

[tdgentoo]
location = /var/db/repos/tdgentoo
sync-type = git
sync-uri = https://github.com/timdodge/tdgentoo.git

# Then sync and install:

sudo emaint sync -r tdgentoo
sudo emerge --ask gui-wm/DankMaterialShell
dacyberduck overlay​

The dacyberduck overlay provides DMS under dank-base/dankmaterialshell.

sudo eselect repository add dacyberduck git https://codeberg.org/dacyberduck/gentoo-overlay.git
sudo emaint sync -r dacyberduck

Or manually in /etc/portage/repos.conf/dacyberduck.conf:

[dacyberduck]
location = /var/db/repos/dacyberduck
sync-type = git
sync-uri = https://codeberg.org/dacyberduck/gentoo-overlay.git

Then sync and install:

sudo emaint sync -r dacyberduck
sudo emerge --ask dank-base/dankmaterialshell

# NixOS​

# All Other Distributions​

This guide doesn't cover compositor installation. You need a compatible Wayland compositor (niri, Hyprland, sway, dwl/MangoWC, Miracle WM, etc.).

1. Install Essential Dependencies​
Quickshell​

If your distribution does not provide a quickshell package, you'll need to build it from source. Quickshell requires:

Base dependencies:

cmake, qt6base, qt6declarative, qtshadertools, pkg-config, cli11
Private Qt headers for qt6declarative (and qt6wayland on Qt < 6.10)
Qt 6.6 or newer
Key features and their dependencies:

Wayland support (enabled by default) - qt6wayland, wayland, wayland-protocols
Crash reporter (recommended) - google-breakpad
Jemalloc (recommended for better memory management) - jemalloc
System tray - qt6dbus
PAM authentication - pam
For complete build instructions and feature flags, see the Quickshell BUILD.md.

AccountsService​
note

AccountsService is needed to persist user profile configurations such as profile pictures. Available in most repositories as accountsservice.

# Arch + Friends
sudo pacman -S accountsservice

# Fedora + Friends
sudo dnf install accountsservice

# Debian, Ubuntu + Friends
sudo apt install accountsservice

# openSUSE + Friends
sudo zypper install accountsservice

# Gentoo
sudo emerge --ask sys-apps/accountsservice

2. Clone the DMS Repository​
git clone https://github.com/AvengeMedia/DankMaterialShell.git ~/dms

3. Compile & Install the DMS Backend​
Requires GO 1.24+

cd ~/dms
sudo make install
note

To uninstall a source build, run sudo make uninstall from the repository directory.

4. Install Optional Integrations​
Install optional components for full functionality using your distribution's package manager:

dgop - Detailed system metrics and process lists
dsearch - Filesystem search engine
matugen - Material Design color palette generation
i2c-tools - ddc monitor backlight control
wl-clipboard + cliphist - Clipboard history
cava - Audio visualizer widget
qt6-multimedia - System sound feedback
Post Install​
After completing installation:

Generate compositor config (niri/Hyprland only): Run dms setup to create a starter configuration with DMS keybinds and autostart. Other compositors (sway, MangoWC, labwc, Miracle WM) are supported but require manual configuration.
Enable the systemd service (recommended) or add dms run to your compositor config
Configure your compositor keybinds - see the Keybinds & IPC guide
Customize appearance via Themes
Extend functionality with Plugins
See Managing Your Installation for detailed guidance on service management, environment variables, and updates.

Systemd Integration (Recommended)​
DankInstall Users

If you used dankinstall, this is already configured. The installer runs systemctl --user enable --now dms during setup.

Enable autostart:

systemctl --user enable dms
Manual control:

# Start DMS now
systemctl --user start dms

# Check status
systemctl --user status dms

# View logs
journalctl --user -u dms -f

# Restart DMS
systemctl --user restart dms

# Disable autostart
systemctl --user disable dms
warning

If using systemd autostart, remove dms run / spawn "dms" "run" / exec-once=dms run from your compositor's configuration to avoid running DMS twice.

Compositor-Specific Systemd Setup​
Different compositors have different levels of systemd session integration. Choose the section that matches your compositor.

Why use add-wants?

If you have multiple desktop environments installed (e.g., Plasma, GNOME, niri), using systemctl --user enable dms starts DMS in all of them. Using add-wants binds DMS to a specific compositor's service or session target, so it only runs where you want it. DMS won't launch when you log into Plasma or GNOME.

niri​
niri has native systemd session integration. Bind DMS to niri's service:

systemctl --user add-wants niri.service dms
DMS starts when niri starts and stops when niri exits. It won't run in other sessions.

Hyprland​
Hyprland doesn't initialize the systemd user session by default. You need to export the environment to systemd for user services to work.

Create a session target:

~/.config/systemd/user/hyprland-session.target

[Unit]
Description=Hyprland Session Target
Requires=graphical-session.target
After=graphical-session.target
Add to your Hyprland config (after any env = lines):

~/.config/hypr/hyprland.conf

exec-once = dbus-update-activation-environment --systemd --all
exec-once = systemctl --user start hyprland-session.target
Bind DMS to the session target:

systemctl --user add-wants hyprland-session.target dms
MangoWC​
MangoWC is a dynamic tiling compositor based on dwl (wlroots). Like other wlroots compositors, it requires manual environment export for systemd user services.

Create a session target:

~/.config/systemd/user/mango-session.target

[Unit]
Description=MangoWC Session Target
Requires=graphical-session.target
After=graphical-session.target
Add to your MangoWC config:

~/.config/mango/config.conf

exec-once=dbus-update-activation-environment --systemd --all
exec-once=systemctl --user start mango-session.target
Bind DMS to the session:

systemctl --user add-wants mango-session.target dms
Sway​
Sway (wlroots-based) needs the environment exported for systemd services.

Create a session target:

~/.config/systemd/user/sway-session.target

[Unit]
Description=Sway Session Target
Requires=graphical-session.target
After=graphical-session.target
Add to your Sway config:

~/.config/sway/config

exec dbus-update-activation-environment --systemd --all
exec systemctl --user start sway-session.target
Bind DMS to the session:

systemctl --user add-wants sway-session.target dms
Miracle WM​
Miracle WM is a tiling Wayland compositor built on Mir. Like other compositors without native systemd session integration, it requires manual environment export.

Create a session target:

~/.config/systemd/user/miracle-wm-session.target

[Unit]
Description=Miracle WM Session Target
Requires=graphical-session.target
After=graphical-session.target
Bind DMS to the session:

systemctl --user add-wants miracle-wm-session.target dms