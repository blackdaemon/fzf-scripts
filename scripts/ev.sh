#!/bin/bash
# vim: set expandtab shiftwidth=4 softtabstop=4 :
# shellcheck disable=SC2142
        
# Function to browse and manipulate environment variables using fzf
# Hotkeys:
#   enter: Put enviromnent variable export statement in the commandline and place cursor after =
#   tab: Put environment variable set statement in the commandline
#   ctrl-n: Put environment variable name in the commandline
#   ctrl-v: Put environment variable value in the commandline
#   ctrl-u: Put environment variable unset statement in the commandline
#   esc: Exit
#
function __ev__() {
    [ -z "$ZSH_VERSION" ] && [ -z "$BASH_VERSION" ] && echo "Not supported shell: $SHELL" && return

    local in_zsh=0
    [ -n "$ZSH_VERSION" ] && in_zsh=1
    
    local input
    if [ $in_zsh -eq 1 ]; then
        input="$BUFFER"
    else
        input="$READLINE_LINE"
    fi

    # Launch fzf to select an environment variable
    local output; output="$(env | fzf \
        --query "$input" \
        --exact --height=10 --layout=reverse \
        --header="Select ehvironment variable   󱗼  tab put  enter export  ctrl-n name  ctrl-v value  ctrl-u unset" \
        --header-first \
        --bind 'tab:become(echo {})' \
        --bind 'enter:become(echo -n "export "; echo {})' \
        --bind 'ctrl-u:become(echo -n "unset "; echo {} | cut -d= -f1)' \
        --bind 'ctrl-n:become(echo -n "$"; echo {} | cut -d= -f1)' \
        --bind 'ctrl-v:become(echo {} | cut -d= -f2)' \
        )"

    # Exit if no selection was made
    if [[ -z "$output" ]]; then
        if [ $in_zsh -eq 1 ]; then
            zle redisplay
        fi
        return
    fi

    # Trim leading tabs (fzf output sometimes has unwanted characters)
    output="${output#*$\"\t\"}"

    # If `READLINE_POINT` is unset, set it to the end of the line
    if [ $in_zsh -eq 1 ]; then
        # zsh
        BUFFER="$output"
        CURSOR=${#BUFFER}
        zle redisplay
    else
        # bash
        READLINE_LINE="$output"
        [[ -z "$READLINE_POINT" ]] && READLINE_POINT="${#READLINE_LINE}" || READLINE_POINT=0x7fffffff
    fi

    # Return early if the output is not an export statement
    [[ "$output" != export\ * ]] && return
    
    # Find the position of '='
    local equal_sign_pos=-1
    local prefix; prefix="${output%%"="*}"
    [[ "$prefix" != "$output" ]] && equal_sign_pos=${#prefix}
    # Return early if there is no '='
    [[ $equal_sign_pos -eq -1 ]] && return

    # Move cursor after '='
    if [ $in_zsh -eq 1 ]; then
        # zsh
        # Move cursor after the '=' symbol
        CURSOR=$(( equal_sign_pos + 1 ))
        # Redraw the command line to reflect changes
        zle redisplay
    else
        # bash
        bind '"\er": redraw-current-line'
        # Move cursor after the '=' symbol
        READLINE_POINT=$(( equal_sign_pos + 1 ))  
        echo -ne "\e[D"  # Move cursor one step back (fine-tuning)
        # Unbind Alt+R after execution
        bind -r "\er"
    fi
}

# Bind ctrl+alt+e
[ -n "$ZSH_VERSION" ] && zle -N __ev__ __ev__ && bindkey '\e\C-e' __ev__
[ -n "$BASH_VERSION" ] && bind -x '"\e\C-e": __ev__'

