
#!/bin/bash

#find Free
free -h

#Checking availability space
df -h

#swap Off
sudo swapoff /swapfile

#Allocate swap
sudo fallocate -l 8G /swapfile

#correct amount of space was reserved
ls -lh /swapfile

#file only accessible to root
sudo chmod 600 /swapfile

#amount of space was reserved for the root
ls -lh /swapfile

#now mark the file as swap space
sudo mkswap /swapfile

#Swap On
sudo swapon /swapfile

#swap Show
sudo swapon --show

#statment 
echo -e "\n\n Swap 8Gb done"

exit 0



