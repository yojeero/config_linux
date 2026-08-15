# vinOS is an Arch layer — install Arch first, then run one command on top.

# T2 Mac

# The T2 chip owns internal keyboard, trackpad, wifi, audio. Stock Arch can’t drive that. Use the community t2linux Arch build with the patched linux-t2 kernel.

# Read + follow t2linux pre-install — Secure Boot off, allow external boot, shrink macOS partition.
# Follow t2linux Arch install. Use t2archinstall (guided) for the easy path.
# Finish Arch. Log in as your user. 

curl -fsSL https://raw.githubusercontent.com/vinpatel/vinos/main/boot.sh | bash

# Reboot; you’re in the vinOS Hyprland desktop with T2 hardware fully working.

# Standard

# Any 2015+ Intel or AMD laptop/desktop.

# Boot the official Arch install ISO (or any Arch flavor’s live media).
# Run archinstall. Pick your kernel, filesystem, timezone, user, sudo. Profile: minimal — vinOS handles the rest.

# Reboot into your new Arch. Log in.

curl -fsSL https://raw.githubusercontent.com/vinpatel/vinos/main/boot.sh | bash
