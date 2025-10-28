 
# =================================
#   arch
# =================================
cd /usr/share/kbd/consolefonts/
ls
sudo pacman -Syu terminus-font
pwd
setfont ter-d22b.psf.gz

sudo nano /etc/vconsole.conf
FONT=ter-d22b.psf.gz
save

# =================================
#   debian
# =================================
dpkg-reconfigure console-setup
UTF-8
Latin1
Terminus
14x28
uname -sr

# ==================================
#   fedora
# ==================================
yum update
yum install terminus-fonts-console
ls /usr/lib/kbd/consolefonts/
setfont ter-v22n

nano .bashrc
sudo nano /etc/vconsole.conf
FONT="ter-v22n" 

setfont ter-v22n






