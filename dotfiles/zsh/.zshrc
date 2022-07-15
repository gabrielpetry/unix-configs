#!/usr/bin/zsh
CURRENT_SHELL=$0
export ZSH_DEBUG=0
autoload -U add-zsh-hook


if [ $ZSH_DEBUG -eq 1 ]; then
    echo "DEBUG ZSH: $ZSH_DEBUG"
    zmodload zsh/zprof
fi

fpath=("$unixconfigs/zsh-completions" $fpath)
autoload -Uz compinit

# exports main repo to a variable
export unixconfigs="$HOME/unix-configs"
# exports scripts folder to a variable
export SCRIPTS="$SCRIPTS_DIR"
export CACHE_DIR="$HOME/.cache"

test -f /etc/resolv.conf || sudo cp /etc/resolv.conf.2 /etc/resolv.conf

source_file_cache="/tmp/.zshrc_cache"
current_date="$(date +'%d')"
last_modified_zsh_cache="$(/bin/ls -l "$source_file_cache" | awk '{print $7}')"
last_modified_completions="$(/bin/ls -l /tmp/.zcompdump | awk '{print $7}')"

if "$last_modified_zsh_cache" != "$current_date"; then
    echo "Creating zshrc cache $source_file_cache"
    echo "loading zshrc_lazy"
    find "$unixconfigs/zshrc_lazy" -type f -maxdepth 1 -exec cat {} \; > $source_file_cache
    echo "loading build functions"
    find "$unixconfigs/zshrc_lazy/build_functions" -type f -maxdepth 1 -exec {} \; >> $source_file_cache
    echo "loading zsh-plugins"
    find "$unixconfigs/zsh-plugins" -type f -maxdepth 1 -exec cat {} \; >> $source_file_cache
fi

# Check if compdump need to be redone
if [ "$last_modified_completions" != "$current_date" ]; then
    echo "Recreating completions"
    compinit
else
    compinit -C
fi


source "$source_file_cache"
source "$unixconfigs/zsh-themes/petry.zsh"
source "$HOME/.zshconfig" || touch "$HOME/.zshconfig" # no versioning


if [ $ZSH_DEBUG -eq 1 ]; then
    echo "DEBUG: $ZSH_DEBUG"
    zmodload zsh/zprof
    zprof
fi

export TERM=xterm-256color
