#!/usr/bin/zsh
# Main variables
CURRENT_SHELL=$0
export ZSH_DEBUG=0
autoload -U add-zsh-hook
autoload -Uz compinit
if [ $ZSH_DEBUG -eq 1 ]; then
    echo "DEBUG ZSH: $ZSH_DEBUG"
    zmodload zsh/zprof
fi

# exports main repo to a variable
export unixconfigs="$HOME/unix-configs"
# exports scripts folder to a variable
export SCRIPTS="$SCRIPTS_DIR"
export CACHE_DIR="$HOME/.cache"

test -f /etc/resolv.conf || sudo cp /etc/resolv.conf.2 /etc/resolv.conf

source_file_cache="/tmp/.zshrc_cache"

if test -f $source_file_cache && [ $(date +'%j') = $(/usr/bin/stat -f '%Sm' -t '%j' ${source_file_cache}) ]; then
else
    echo "Creating zshrc cache $source_file_cache"
    find "$unixconfigs/zshrc_lazy" -type f -maxdepth 1 -exec cat {} \; > $source_file_cache
    
    find "$unixconfigs/zshrc_lazy/build_functions" -type f -maxdepth 1 -exec {} \; >> $source_file_cache
    
    find "$unixconfigs/zsh-plugins" -type f -maxdepth 1 -exec cat {} \; >> $source_file_cache
    
fi
source "$source_file_cache"

# %j == day of year
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
    compinit
else
    compinit -C
fi

source "$unixconfigs/zsh-themes/petry.zsh"
if [ $ZSH_DEBUG -eq 1 ]; then
    echo "DEBUG: $ZSH_DEBUG"
    zmodload zsh/zprof
    zprof
fi

# uncomment for clearing zsh cache
# rm "$source_file_cache"
#
export TERM=xterm

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
