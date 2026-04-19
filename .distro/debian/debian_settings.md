
# adding a non-free repository
sudo apt-add-repository non-free contrib 

# For proprietary x64 drivers
sudo apt install linux-headers-amd64

# x32 без PAE
sudo apt install linux-headers-686

# x32 PAE
sudo apt install linux-headers-686-pae

# Adding the latest kernel for the latest drivers
sudo apt install -t bookworm-backports

# install Debian Bookworm drivers
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
sudo apt update
sudo apt install nvidia-driver firmware-misc-nonfree

# list installed packagers
dpkg --list 
