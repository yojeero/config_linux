# linux backup	------

# create a full backup of the /home directory to the file /tmp/home0.bak
dump -0aj -f /tmp/home0.bak /home

# create an incremental backup of the /home directory to the file /tmp/home0.bak
dump -1aj -f /tmp/home0.bak /home

# restore from backup /tmp/home0.bak
restore -if /tmp/home0.bak

# sync /tmp with /home
rsync -rogpav —delete /home /tmp

# sync via SSH tunnel
rsync -rogpav -e ssh —delete /home ip_address:/tmp

# synchronized local directory with a successful director of ssh-tunnel with compression
rsync -az -e ssh --delete ip_addr:/home/public /home/local

# synchronizes successful directory with local directory ssh-tunnel with compression
rsync -az -e ssh —delete /home/local ip_addr:/home/public

# make a “snapshot” of the local disk into a file on a remote computer via an ssh tunnel
dd bs=1M if=/dev/hda | gzip | ssh user@ip_addr ‘dd of=hda.gz’

# create an incremental backup of the ‘/home/user’ directory to the backup.tar file, preserving the permissions
tar -Puf backup.tar /home/user

# copying the contents of /tmp/local to a remote computer via an ssh tunnel to /home/share
( cd /tmp/local/ && tar c . ) | ssh -C user@ip_addr ‘cd /home/share/ && tar x-p’

# copying the contents of /home to a remote computer via an ssh tunnel to /home/backup-home
( tar c /home ) | ssh -C user@ip_addr ‘cd /home/backup-home && tar x -p’

# copying one directory to another while maintaining permissions and links
tar cf — . | (cd /tmp/backup ; tar xf — )

# search /home/user1 for all files whose names end in '.txt' and copy them to another directory
find /home/user1 -name ‘*.txt’ | \ xargs cp -av —target-directory=/home/backup/ —parents

# search /var/log for all files whose names end in ‘.log’ and create a bzip archive from them
find /var/log -name ‘*.log’ | tar cv —files-from=- | bzip2 > log.tar.bz2
