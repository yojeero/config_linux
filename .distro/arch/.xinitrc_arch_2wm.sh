Edit your ~/.xinitrc. Replace the final exec bspwm run line with

# 1.... ваши начальные настройки (feh, picom, xset и т.д.) ...

case "$1" in
    herbstluftwm|hlwm)
        exec herbstluftwm
        ;;
    bspwm|*)
        exec bspwm
        ;;
esac

#2 Now from TTY (via fish) you can launch them manually:
# startx -will start bspwm by default.
# startx ~/.xinitrc herbstluftwm -will start herbstluftwm

# 3. To avoid writing a long command, add abbreviations (abbr abbreviations in fish are more convenient than aliases) to the configuration file ~/.config/fish/config.fish

abbr -a sx-bspwm 'startx'
abbr -a sx-hlwm 'startx ~/.xinitrc herbstluftwm'
