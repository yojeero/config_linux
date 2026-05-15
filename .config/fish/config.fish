
set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# vi
abbr -a n nano
abbr -a v nvim
abbr -a _ sudo
abbr -a _e sudoedit

# eza
abbr -a ld eza -lD
abbr -a lh eza -dl .* --group-directories-first
abbr -a ll eza -al --group-directories-first
abbr -a lt eza -al --sort=modified
abbr -a lf "eza -lF --color=always | grep -v /"
abbr -a ls "eza -alF --color=always --sort=size | grep -v /"

# pnpm
abbr -a ni pnpm install
abbr -a nr pnpm run
abbr -a nd pnpm run dev
abbr -a nb pnpm run build

# Git
abbr -a gs git status
abbr -a gi git init
abbr -a ga git add .
abbr -a gaa git add -A
abbr -a gc git commit -m
abbr -a gd git diff HEAD
abbr -a go git push -u origin
abbr -a gco git checkout

# GNU 
abbr -a diff diff --color=auto
abbr -a df gdf -h
abbr -a du gdu -h
abbr -a grep ggrep --color=auto
abbr -a chmod gchmod --preserve-root -v
abbr -a chown gchown --preserve-root -v
abbr -a find gfind

# clear
abbr -a c clear
abbr -a ka killall

# Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi --cwd-file="$tmp" $argv
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# fzf to config folder
function _fzf_change_directory
    if read -l foo
        if test -n "$foo"
            builtin cd (string unescape -- $foo)
            commandline -r ''
            commandline -f repaint
        end
    else
        commandline ''
    end
end

function fzf_change_directory
    begin
        # config folder
        echo $HOME/.config        
        # Search for ghq repos
        if type -q ghq
            # Searches for .git folders inside the ghq root up to 4 levels
            string match -r '.*/[^/]+' (ghq root)/**/.git | string replace '/.git' ''
        end        
        #. Current eza subfolders
        eza -d */2>/dev/null | string replace -r '/$' '' | string match -v '*.git*'
    # development folder
        string match -v '*.git*' $HOME/Developments/*/*
    end | string match -r '.+' | uniq | fzf | _fzf_change_directory
end

# in Kitty or Foot press Ctrl + G to open a list of folders
# pressing Enter, you will instantly move to it
bind \cg fzf_change_directory


