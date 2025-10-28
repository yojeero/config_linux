# linux backup	------

# создать полную резервную копию директории /home в файл /tmp/home0.bak
dump -0aj -f /tmp/home0.bak /home
    
# создать инкрементальную резервную копию директории /home в файл/tmp/home0.bak	
    dump -1aj -f /tmp/home0.bak /home
    
# восстановить из резервной копии /tmp/home0.bak
    restore -if /tmp/home0.bak
    
# синхронизировать /tmp с /home
rsync -rogpav —delete /home /tmp
    
# синхронизировать через SSH-туннель

rsync -rogpav -e ssh —delete /home ip_address:/tmp
    
# синхронизировать локальную директорию с удалённой директорией через ssh-туннель со сжатием	

rsync -az -e ssh --delete ip_addr:/home/public /home/local
    
# синхронизировать удалённую директорию с локальной директорией через ssh-туннель со сжатием

rsync -az -e ssh —delete /home/local ip_addr:/home/public
    
# сделать «слепок» локального диска в файл на удалённом компьютере через ssh-туннель	

dd bs=1M if=/dev/hda | gzip | ssh user@ip_addr ‘dd of=hda.gz’
    
# создать инкрементальную резервную копию директории ‘/home/user’ в файл backup.tar с сохранением полномочий

tar -Puf backup.tar /home/user
    
# копирование содержимого /tmp/local на удалённый компьютер через ssh-туннель в /home/share

( cd /tmp/local/ && tar c . ) | ssh -C user@ip_addr ‘cd /home/share/ && tar x-p’
    
# копирование содержимого /home на удалённый комп через ssh-туннель в /home/backup-home

( tar c /home ) | ssh -C user@ip_addr ‘cd /home/backup-home && tar x -p’
    
# копирование одной директории в другую с сохранением полномочий и линков

tar cf — . | (cd /tmp/backup ; tar xf — )
    
# поиск в /home/user1 всех файлов, имена которых оканчиваются на ‘.txt’, и копирование их в другую директорию

find /home/user1 -name ‘*.txt’ | \ xargs cp -av —target-directory=/home/backup/ —parents
    
# поиск в /var/log всех файлов, имена которых оканчиваются на ‘.log’, и создание bzip-архива из них

find /var/log -name ‘*.log’ | tar cv —files-from=- | bzip2 > log.tar.bz2
