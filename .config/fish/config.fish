set fish_greeting ""

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

set -gx MICRO_TRUECOLOR 1

# nano
abbr -a n nano
abbr -a _ sudo
abbr -a _e sudoedit

# Git
abbr -a gs git status
abbr -a gi git init
abbr -a ga git add .
abbr -a gaa git add -A
abbr -a gc git commit -m
abbr -a gd git diff HEAD
abbr -a go git push -u origin
abbr -a gco git checkout

# clear
abbr -a c clear
abbr -a ka killall

# Import Gentoo system environment 
if test -f /etc/profile.env
    sed -E 's/^export ([A-Za-z0-9_]+)=(.*)$/set -gx \1 \2/' /etc/profile.env | source
end