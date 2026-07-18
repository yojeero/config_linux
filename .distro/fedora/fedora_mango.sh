Fedora Everything Netinstall

# Everything позволяет при установке выбрать пункт Minimal Install (только консоль и драйверы Intel), чтобы вы не тянули за собой лишний мусор и чужие панели.

## Шаг 2: Базовая настройка системы после установки

# После первой загрузки в консоль, сразу подключите репозитории с кодеками и софтом (Flathub), чтобы не думать об этом в будущем:

# Обновляем пакетную базу (в Fedora 41+ и 44 используется сверхбыстрый dnf5)
sudo dnf upgrade --refresh

# Включаем RPM Fusion (свободные и несвободные кодеки/софт)
sudo dnf config-manager --set-enabled rpmfusion-free rpmfusion-nonfree

# Включаем поддержку Flatpak приложений
flatpak remote-add --if-not-exists flathub https://flathub.org

## Шаг 3: Установка графического стека и River
sudo dnf install river waybar foot fuzzel swaybg mako ly

# ly — это отличный, минималистичный TUI (текстовый) дисплейный менеджер, который идеально подходит для тайлинговых сред. 
sudo systemctl enable ly
sudo systemctl set-default graphical.target

## Шаг 4: Накат ваших конфигурационных файлов

   1. Конфиг River в ~/.config/river/init (сделать исполняемым: chmod +x).
   2. Настройки панели в ~/.config/waybar/config.jsonc и ~/.config/waybar/style.css.

## Шаг 5: Перезагрузка и запуск
sudo reboot

## Почему эта связка будет просто работать?

* Intel Graphics: Драйверы находятся прямо в ядре Linux. Никаких «черных экранов» после обновлений, как это бывает с Nvidia.
* Никакого обслуживания: Раз в пару недель или месяц вы можете запустить sudo dnf upgrade, система обновит прикладной софт, не ломая ваши файлы конфигурации.

# Автомонтирование флешек udiskie
sudo dnf install udiskie

# Для River / MangoWM:
# Откройте ваш  ~/.config/river/init или конфиг MangoWM и добавьте строку автозапуска в самый конец файла
exec udiskie -t &

# Блокировщик экрана swaylock-effects
sudo dnf install swaylock-effects

# Создайте скрипт блокировки ~/.local/bin/lock.sh:
   
   mkdir -p ~/.local/bin
   touch ~/.local/bin/lock.sh
   chmod +x ~/.local/bin/lock.sh
   
# Откройте файл и вставьте в него команду с красивыми параметрами размытия и кольца ввода:
   
   #!/bin/sh
   swaylock \
     --screenshots \
     --clock \
     --indicator \
     --indicator-radius 100 \
     --indicator-thickness 7 \
     --effect-blur 7x5 \
     --effect-vignette 0.5:0.5 \
     --ring-color 81a1c1 \
     --key-hl-color a3be8c \
     --line-color 00000000 \
     --inside-color 2e3440e6 \
     --text-color d8dee9

# Чтобы блокировать экран вручную по нажатию Super + Escape:

# River (~/.config/river/init)    
    riverctl map normal $MOD Escape spawn ~/.local/bin/lock.sh
    
# Mango (~/.config/mango/config.conf)    
    bind = $mod, Escape, spawn, ~/.local/bin/lock.sh
      
# Чтобы ноутбук блокировался автоматически при закрытии крышки или долгом простое, в мире Wayland используется легковесный демон swayidle.
sudo dnf install swayidle

# Пропишите запуск swayidle в конфиг вашего композитора (river/init или mango/config.conf):
   
# Для River / Mango
exec swayidle -w timeout 300 '~/.local/bin/lock.sh' before-sleep '~/.local/bin/lock.sh' &   


# ----------------------------------
# mango
# ----------------------------------
sudo dnf copr enable dennemann/MangoWC && sudo dnf install mangowm