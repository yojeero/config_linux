
sudo pacman -Rsn gnome-extra





# List packages
ls /var/cache/pacman/pkg/ | less 

# Remove all pkg except those installed
sudo pacman -Sc 

# Remove all files
sudo pacman -Scc

### Automatically remove
sudo pacman -S pacman-contrib

# Remove
paccache -r

# Systemd timer
# create file in `/etc/systemd/system/paccache.timer` with the following contents

[Unit]
Description=Clean-up old pacman pkg cache

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=multi-user.target

# Enable by `sudo systemctl start paccache.timer`
Pacman post-transaction hook

# List unused
sudo pacman -Qtdq

# Remove unused
sudo pacman -R $(pacman -Qtdq)



