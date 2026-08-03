fc-cache -f -v

fc-list : family | sort -u

# extract ALL from .tar.xz
# if no - install - xz
for f in *.tar.xz; do tar -xf "$f"; done


