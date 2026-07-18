
# ----------------------------------
# sway
# ----------------------------------
emerge --ask --getbinpkg \
    gui-wm/sway gui-apps/swaybg gui-apps/swayidle gui-apps/swaylock gui-apps/swaylock-effects \
    gui-apps/foot gui-apps/waybar gui-apps/fuzzel gui-apps/mako \
    gui-apps/grim gui-apps/slurp x11-misc/wl-clipboard \
    sys-apps/xdg-desktop-portal-gtk

#     Дополнительные рекомендации перед запуском
#     Флаги USE: 
#     Для правильной работы swaybg (обоев) убедитесь, что у вас включен флаг jpeg (или gdk-pixbuf), иначе фоновые изображения в формате .jpg не загрузятся.
    
#     Управление сессиями: 
    Sway потянет за собой sys-auth/seatd или sys-auth/elogind. 
    
#     Если вы используете OpenRC, не забудьте добавить используемый сервис управления сессиями в автозагрузку 
    rc-update add seatd boot
