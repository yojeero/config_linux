# -------------------------------------------
# Debian trixie Regolith 
# -------------------------------------------

# Register the Regolith public key to your local apt
wget -qO - https://archive.regolith-desktop.com/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

# Add the repository URL to your local apt
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/debian/stable trixie v3.4" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# Update apt and install Regolith
sudo apt update
sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille xdg-desktop-portal-regolith

# Restart

# -------------------------------------------
# Ubuntu Regolith 
# -------------------------------------------

# Register the Regolith public key to your local apt
wget -qO - https://archive.regolith-desktop.com/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

# Add the repository URL to your local apt
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/stable questing v3.4" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# Update apt and install Regolith
sudo apt update
sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille xdg-desktop-portal-regolith

# Restart