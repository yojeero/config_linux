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

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# npm
alias ni="pnpm install"
alias nr="pnpm run"
alias nd="pnpm run dev"
alias nb="pnpm run build"

# git
alias gs="git status"
alias gi="git init"
alias ga="git add ."
alias gaa="git add -A"
alias gc="git commit -m"
alias gd="git diff HEAD"
alias go="git push -u origin"
alias gco="git checkout"

# pretty git log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# all local branches in the order of their last commit
alias gb="git for-each-ref --sort='-authordate:iso8601' --format=' %(color:green)%(authordate:iso8601)%09%(color:white)%(refname:short)' refs/heads"

# pkg
alias n=nano
alias v=nvim
alias _=sudo 
alias _e=sudoedit

# list
alias ld='eza -lD' # output only directories (no files)
alias lf='eza -lF --color=always | grep -v /' # prints files only (no directories)
alias lh='eza -dl .*--group-directories-first' # Displays only hidden files (no directories)
alias ll='eza -al --group-directories-first' # prints everything, with directories first
alias ls='eza -alF --color=always --sort=size | grep -v /' # prints only files sorted by size
alias lt='eza -al --sort=modified' # displays all files sorted by update time

# fzf 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=16"
source <(fzf --zsh) 2>/dev/null

# fd fzf
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --exclude .git --exclude node_modules'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"fi
