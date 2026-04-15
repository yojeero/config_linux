# ===================================
# https://danklinux.com/
# (niri or hyprland) + DankMaterialShell
# ===================================
curl -fsSL https://install.danklinux.com | sh

# Dependencies​
dgop - Detailed system metrics and process lists
dsearch - Filesystem search engine
matugen - Material Design color palette generation
i2c-tools - ddc monitor backlight control
wl-clipboard + cliphist - Clipboard history
cava - Audio visualizer widget
qt6-multimedia - System sound feedback

# After completing installation:

Generate compositor config (niri/Hyprland only): Run dms setup to create a starter configuration with DMS keybinds and autostart. Other compositors (sway, MangoWC, labwc, Miracle WM) are supported but require manual configuration.
Enable the systemd service (recommended) or add dms run to your compositor config
Configure your compositor keybinds - see the Keybinds & IPC guide
Customize appearance via Themes
Extend functionality with Plugins
See Managing Your Installation for detailed guidance on service management, environment variables, and updates.

# Systemd Integration 

# DankInstall Users
If you used dankinstall, this is already configured. The installer runs systemctl --user enable --now dms during setup.

# Enable autostart
systemctl --user enable dms

# Manual control

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

If using systemd autostart, remove dms run / spawn "dms" "run" / exec-once=dms run from your compositor's configuration to avoid running DMS twice.

Compositor-Specific Systemd Setup​
Different compositors have different levels of systemd session integration. Choose the section that matches your compositor.

Why use add-wants?

If you have multiple desktop environments installed (e.g., Plasma, GNOME, niri), using systemctl --user enable dms starts DMS in all of them. Using add-wants binds DMS to a specific compositor's service or session target, so it only runs where you want it. DMS won't launch when you log into Plasma or GNOME.

# niri​
niri has native systemd session integration. Bind DMS to niri's service:

systemctl --user add-wants niri.service dms

DMS starts when niri starts and stops when niri exits. It won't run in other sessions.

# Hyprland​
Hyprland doesn't initialize the systemd user session by default. You need to export the environment to systemd for user services to work.

# Create a session target
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