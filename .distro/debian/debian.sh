
# ----------------------------------
# repo+system
# ----------------------------------

    sudo apt-add-repository -y non-free contrib 
    sudo apt install -y linux-headers-amd64
    sudo systemctl enable --now fstrim.timer
    sudo nano /etc/apt/sources.list.d/debian.sources

# В строке Components: через пробел допишите 
Components: main contrib non-free non-free-firmware

sudo apt update