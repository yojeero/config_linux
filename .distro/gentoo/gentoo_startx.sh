

# Переключись в TTY

# Если висит tuigreet/чёрный экран

# Нажми
Ctrl + Alt + F2

# Залогинься

# Проверь запускается ли X вручную

# Под пользователем выполни
startx

# Это главное.

# Если BSPWM запустился

# Тогда проблема ТОЛЬКО в greetd/tuigreet.

# Если startx падает

# Покажи ошибки
cat ~/.local/share/xorg/Xorg.0.log | tail -50

# и
startx

# Быстрое исправление

# Сделай минимальный .xinitrc
nano ~/.xinitrc

# Вставь

#!/bin/sh
exec bspwm

# Потом
chmod +x ~/.xinitrc

# И снова
startx

# Если пишет "command not found"

# Проверь
which bspwm
which sxhkd
which Xorg

# Проверь seatd
systemctl status seatd

# Если не active
sudo systemctl enable --now seatd

# Временно отключи greetd

# Чтобы не мешал
sudo systemctl disable greetd --now

# Сделай простой автологин через tty

# Под пользователем
nano ~/.bash_profile

# Вставь
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi

# Теперь после логина в tty1 будет запускаться bspwm.

# Это проще и стабильнее, чем greetd.

# Если startx пишет "no screens found"

# Тогда проблема в Xorg/drivers.

# Если чёрный экран после startx

# Часто это:

# не стартует sxhkd
# сломан bspwmrc
# нет терминала

# Тогда
mv ~/.config/bspwm/bspwmrc ~/.config/bspwm/bspwmrc.old
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
chmod +x ~/.config/bspwm/bspwmrc

# Самый стабильный вариант

# Я бы рекомендовал пока вообще убрать
greetd
tuigreet

# сделать
TTY → login → startx → bspwm

# Это проще для первой Gentoo.

# Минимально рабочая конфигурация

.xinitrc
#!/bin/sh
exec bspwm

# .bash_profile
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi

# services
sudo systemctl enable NetworkManager
sudo systemctl enable seatd