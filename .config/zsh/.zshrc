#.zshrc

# %1~ shows only the name of the current folder, replacing home with ~
PROMPT='%F{cyan}%1~%f %F{purple}❯%f '

# command history
HISTSIZE=5000
HISTFILE=~/.cache/zsh/history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# setting
bindkey -e # emacs style (Ctrl+A, Ctrl+E)
setopt autocd # go to folder simply by name without 'cd'

# completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select # select with arrows
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case insensitive

# fzf 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=16"
source <(fzf --zsh) 2>/dev/null

# fd fzf
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --exclude .git --exclude node_modules'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"fi

  [[ -f ~/.config/alias ]] && source ~/.config/alias
