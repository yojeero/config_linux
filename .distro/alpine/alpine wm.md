
# Alpine Linux

# ================================
# xfce  
# 1) setup-basic-postinstal 
# 2) setup-xfce4 (any wm)
# ================================
# BASIC
./setup-basic-postinstal >> 
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/setup-basic-postinstal | sh

# DESKTOP WM

# BSPWM 
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/bspwm/setup-bspwm | bash

# PLASMA 
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/kde-plasma/setup-kde | bash

# XFCE4 
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/xfce4/setup-xfce4 | bash

# GNOME 
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/gnome/setup-gnome | bash

# UTILS DESKTOP

# FLATPACK 
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/utils/setup-flatpak | bash

# alpine-linux LXC (Proxmox)
./setup-basic-postinstal-lxc >> Configuraciones basicas para Alpine LXC (Proxmox)
wget --no-cache -O - https://raw.githubusercontent.com/afimpel/alpine-linux/master/setup-basic-postinstal-lxc | sh

# betterlockscreen
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
