echo 'export ZDOTDIR=$HOME/.config/zsh' > ~/.zshenv

# the user directory will be littered with files with a dot at the beginning of the name 
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# define this variable so that zsh configs are searched in this directory
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
