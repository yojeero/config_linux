# ----------------------------------
# https://danklinux.com/
# ----------------------------------

curl -fsSL https://install.danklinux.com | sh

# ----------------------------------
# Debian Trixie Dank 
# ----------------------------------

# DankLinux repo
curl -fsSL https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_13/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/danklinux.gpg
echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_13/ /" | \
  sudo tee /etc/apt/sources.list.d/danklinux.list

# DMS stable repo
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_13/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_13/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms.list

sudo apt update

# ----------------------------------
# Debian Sid Dank
# ----------------------------------

# DankLinux repo
curl -fsSL https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_Unstable/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/danklinux.gpg
echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_Unstable/ /" | \
  sudo tee /etc/apt/sources.list.d/danklinux.list

# DMS stable repo
curl -fsSL https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_Unstable/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/avengemedia-dms.gpg
echo "deb [signed-by=/etc/apt/keyrings/avengemedia-dms.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/Debian_Unstable/ /" | \
  sudo tee /etc/apt/sources.list.d/avengemedia-dms.list

sudo apt update

# install stable
sudo apt install dms















# -------------------------------------------
# Ubuntu Dank 
# ------------------------------------------- 
sudo add-apt-repository ppa:avengemedia/danklinux
sudo add-apt-repository ppa:avengemedia/dms
sudo apt update
sudo apt install dms
