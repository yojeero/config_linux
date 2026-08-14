 
 # show xfce date+time in one row
  %a %b %e, %R%P     
  
 # Full Desktop Backup
 tar -czvf xfce-config-backup.tar.gz ~/.config/xfce4
 
 # Restore command / best done from a non-Xfce TTY session.
 tar -xzvf xfce-config-backup.tar.gz -C ~/ 
