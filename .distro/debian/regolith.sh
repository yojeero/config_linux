# ----------------------------------
# Debian trixie Regolith 
# ----------------------------------

# Regolith public key
wget -qO - https://archive.regolith-desktop.com/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

# Add the repo to your local apt
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/debian/stable trixie v3.4" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# install
sudo apt update
sudo apt install -y \
            regolith-desktop regolith-session-flashback \
            regolith-look-lascaille xdg-desktop-portal-regolith

sudo reboot

# ----------------------------------
# Ubuntu Regolith 
# ----------------------------------

# Regolith public key
wget -qO - https://archive.regolith-desktop.com/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

# Add the repo to your local apt
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/stable questing v3.4" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# install 
sudo apt update
sudo apt install -y \
            regolith-desktop regolith-session-flashback \
            regolith-look-lascaille xdg-desktop-portal-regolith

sudo reboot