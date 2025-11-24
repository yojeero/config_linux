# login - anon, root
# pass - voidlinux

# run instaling Void
void-installer

# --------------------------------
# Bash aliases
# --------------------------------
sudo nano ~/.bash_aliases

# Add this script
alias xu='sudo xbps-install xbps && sudo xbps-install -Suv'
alias xin='sudo xbps-install'
alias xr='sudo xbps-remove -Rcon'
alias xl='xbps-query -l'
alias xf='xl | grep'
alias xs='xbps-query -Rs'
alias xd='xbps-query -x'
alias clrk='sudo vkpurge rm all && sudo rm -rf /var/cache/xbps/*'
alias halt='sudo halt'
alias poweroff='sudo poweroff'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

# Open bash config file
sudo nano ~/.bashrc

# Add this line
if [ -f ~/.bash_aliases ]; then 
    . ~/.bash_aliases;
fi

# --------------------------------
# Office
# --------------------------------
sudo xbps-install libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw libreoffice-math libreoffice-base libreoffice-gnome libreoffice-i18n-en-US

# Install CUPS
sudo xbps-install cups cups-pk-helper cups-filters foomatic-db foomatic-db-engine

# Enable CUPS service
sudo ln -sv /etc/sv/cupsd /var/service

# Epson Printer
sudo xbps-install -Rs epson-inkjet-printer-escpr imagescan iscan-data
# HP Printer:
sudo xbps-install -Rs hplip-gui
# Canon Printer:
sudo xbps-install -Rs cnijfilter2
# Brother Printer:
sudo xbps-install -Rs brother-brlaser

# SANE scanner driver for brscan3-compatible Brother scanners
sudo xbps-install brother-brscan3
# SANE scanner driver for brscan4-compatible printers 
sudo xbps-install brother-brscan4 
# CUPS wrapper driver for the brother DCP-197C printer/scanner
sudo xbps-install brother-dcp197c-cupswrapper 
# LPR driver for the brother DCP-197C printer/scanner 
sudo xbps-install brother-dcp197c-lpr 

# ----------------------------------
# Flatpak
# ----------------------------------
sudo xbps-install -S flatpak

# Add the Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo