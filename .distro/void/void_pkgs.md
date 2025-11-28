
# -------------------------------------------------
# VSCode
# --------------------------------------------------
wget https://update.code.visualstudio.com/latest/linux-x64/stable -O vscode.tar.gz
tar -xzf vscode.tar.gz
sudo mv VSCode-linux-x64 /opt/vscode
sudo ln -s /opt/vscode/bin/code /usr/local/bin/code

code

# Node.js and npm
sudo xbps-install -S nvm
nvm install --lts
nvm use --lts
npm install -g pnpm serve vite

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