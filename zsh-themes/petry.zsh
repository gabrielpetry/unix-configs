# Execution time start
cmd_exec_time_preexec_hook() {
    CMD_EXEC_start=$(date +%s)
}

# Execution time end
cmd_exec_time_precmd_hook() {
    [[ -z $CMD_EXEC_start ]] && return
    local CMD_EXEC_stop=$(date +%s)
    CMD_EXEC_duration=$(( $CMD_EXEC_stop - $CMD_EXEC_start ))
    unset CMD_EXEC_start
}

_gitbranch() {
    GBRANCH="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
    if [ -n "$GBRANCH" ]; then
        DIRTY="$(git status --porcelain 2> /dev/null | wc -l)"
        if [ $DIRTY -gt 0 ]; then
            echo " on $(_red "$GBRANCH*")"
        else
            echo " on $(_green "$GBRANCH")"
        fi
    fi
}

add-zsh-hook preexec cmd_exec_time_preexec_hook
add-zsh-hook precmd cmd_exec_time_precmd_hook

_EXEC_TIME() {
    [[ -z $CMD_EXEC_duration ]] && return
    
    if [[ $CMD_EXEC_duration -ge 60 ]]; then
        echo "$(_red "$CMD_EXEC_duration"s)"
        return
        elif [[ $CMD_EXEC_duration -ge 30 ]]; then
        echo "$(_yellow "$CMD_EXEC_duration"s)"
        return
    else
        echo "$(_green "$CMD_EXEC_duration"s)"
    fi
}

setopt PROMPT_SUBST
_RED="$(tput setaf 1)"
_GREEN="$(tput setaf 2)"
_YELLOW="$(tput setaf 3)"
_BLUE="$(tput setaf 4)"
_MAGENTA="$(tput setaf 5)"
_CYAN="$(tput setaf 6)"
_WHITE="$(tput setaf 7)"
_RESET="$(tput sgr0)"

_red() {
    echo "$_RED$@$_RESET"
}

_green() {
    echo "$_GREEN$@$_RESET"
}

_yellow() {
    echo "$_YELLOW$@$_RESET"
}

_blue() {
    echo "$_BLUE$@$_RESET"
}

_exists() {
    command -v "$1" >/dev/null 2>&1 | grep -q '/'
}

_language_node() {
    _exists node && node -v 2>/dev/null
}

_language_shell() {
    zsh --version | awk '{print $1 $2}'
}

_language_version() {
    # check if exists package.json or js files
    if ls '*.js' 1> /dev/null 2>&1; then
        echo "node"
    else
        echo $(_language_shell)
    fi
}

_date() {
    date +%H:%M:%S
}

_bold() {
    echo "%B$@%b"
}

_print_path() {
    current_dir="$(pwd | sed "s|$HOME|~|")"
    last_part="$(echo "$current_dir" | awk -F'/' '{print $NF}')"
    start_part="$(echo "$current_dir" | sed "s/$last_part//g")"
    echo "$start_part$(_bold $(_blue $last_part))"
}

setopt PRINT_EXIT_VALUE

machineHostname() {
    hostname=$(hostname -s | sed 's/[^a-zA-Z0-9]//g')
    if [[ -n "$hostname" ]]; then
        echo "$(_bold $(_blue $hostname))@"
    fi
}

PROMPT='$(_blue "$(machineHostname)%n"):$(_print_path %~)$(_gitbranch) %(?.$(_green 0).$(_red %?)):$(_EXEC_TIME)
$(_date) %(!.#.$) '
