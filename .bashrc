#!/bin/sh

# EXPORTABLE PART

#-------------------------------------------------
export EDITOR="emacs"

# ALIAS
alias rm="rm -i"
alias rmd="rm -rfi"
alias emacs="emacs -nw"
alias ee="emacs"
alias grepl="grep --exclude-dir={vendor,node_modules,storage,public} --exclude=\*.{lock,git,scss}"
alias d="docker"
alias dc="docker-compose"
alias dce="docker-compose exec"
alias c="clear"
alias cl="clear; source ~/.bashrc || source ~/.bash_profile"
alias all-functions="compgen -c"
alias cdg="cd_git_project"
alias g="git"

# map git completion to 'g'
__git_complete g __git_main 2>/dev/null # mac
complete -o default -o nospace -F _git g 2>/dev/null # linux

#-------------------------------------------------
# FUNCTION
cd_git_project() {
    pdir=$(g pdir 2>/dev/null)
    
    if [ ! -z "${pdir}" ]
    then
        cd "${pdir}"
    fi
}

ev() {
    emacs "$1" --eval '(setq buffer-read-only t)'
}

trash() {
    mv "$@" ~/.Trash/
}

gitgraph() {
    args=""
    while [ "$1" != "" ]; do
        case $1 in
            -a | --all )    args="${args} --all"
                            ;;
            * )             ;;
        esac
        shift
    done
    git log --graph --decorate --pretty=oneline --abbrev-commit ${args}
}

#-------------------------------------------------
# ETERNAL BASH HISTORY

# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss

if ! grep -q 'history -a' <<< "${PROMPT_COMMAND}";
then
    PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
fi

#-------------------------------------------------
# SSH SET UP

# Add ssh to keychain to avoid password prompt everytime
ssh-add -K ~/.ssh/id_rsa &>/dev/null

#-------------------------------------------------
# PROMPT BACKGROUND AND FOREGROUND

prompt_color_escape() {
    # Make sure using escape \] for PS1
    echo '\[\e['$@'m\]'

    # echo '\[\033['$@'m\]'
}

set=$(prompt_color_escape '00')
RESET=$(prompt_color_escape '')

# 01; bold version of that color
# 38;5; foreground color
# 48;5; background color
BG_RED=$(prompt_color_escape '48;5;009')

FG_CYAN=$(prompt_color_escape '01;38;5;075')
FG_BRIGHT_GREEN=$(prompt_color_escape '01;38;5;118')
FG_YELLOW=$(prompt_color_escape '01;38;5;226')
FG_ORANGE=$(prompt_color_escape '01;38;5;214')
FG_WHITE=$(prompt_color_escape '01;38;5;231')
FG_RED=$(prompt_color_escape '01;38;5;009')

FG_BOLD=$(prompt_color_escape '01')
FG_BOLD_RESET=$(prompt_color_escape '21')

get_git_prompt() {
    current_branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/)*$//' -e 's/* (*\(.*\)/\1/' -e 's/^[Hh][Ee][Aa][Dd] detached at /\
:/')

    # if there is no branch, don't display anything
    # quote the variable in case of string with multiple words
    if [ -z "${current_branch}" ]
    then
        return 0
    fi

    remote_tracking_branch=$(git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)" 2>/dev/null);

    if [ ! -z "${remote_tracking_branch}" ]
    then
        read ahead behind <<< $(git rev-list --left-right --count ${current_branch}...${remote_tracking_branch} 2>/dev/null)

        if [ ${ahead} -gt 0 ]
        then
            current_branch=${current_branch}' ↑'${ahead}
        fi

        if [ ${behind} -gt 0 ]
        then
            current_branch=${current_branch}' ↓'${behind}
        fi
    fi
    
    git_status_count=$(git status -s 2>/dev/null | wc -l | sed -e 's/[[:space:]]*//g')

    git_stash_count=$(git stash list 2>/dev/null | wc -l | sed -e 's/[[:space:]]*//g')

    git_conflict_count=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | sed -e 's/[[:space:]]*//g')

    if [ ${git_status_count} -eq 0 ]
    then
        git_status_count=${FG_BRIGHT_GREEN}'✔' # ✔✓
    else
        git_status_count='▲'${git_status_count}
    fi

    if [ ${git_stash_count} -eq 0 ]
    then
        git_stash_count=''
    else
        git_stash_count='⚑'${git_stash_count}
    fi

    if [ ${git_conflict_count} -eq 0 ]
    then
        git_conflict_count=''
    else
        git_conflict_count=${FG_RED}'✗'${git_conflict_count}
    fi

    # squeeze spaces into single space | then remove all trailing spaces
    echo " (${current_branch}) ${git_status_count} ${git_stash_count} ${git_conflict_count}" | tr -s " " | sed -e 's/[[:space:]]*$//'
}

set_bash_prompt() {
    PS1="${SET}${FG_WHITE}${BG_RED}\u@\h${RESET}${FG_BRIGHT_GREEN} \w${FG_YELLOW}$(get_git_prompt)${RESET}\n${FG_CYAN}\$${RESET} "
}

# Note: append to PROMPT_COMMAND to keep default prompt behavior
# use PROMPT_COMMAND to be able to reload the whole PS1 and refresh prompt color correctly
if ! grep -q 'set_bash_prompt' <<< "${PROMPT_COMMAND}";
then
    PROMPT_COMMAND="set_bash_prompt; $PROMPT_COMMAND"
fi


#-------------------------------------------------

function cd_up() {
    cd $(printf "%0.s../" $(seq 1 $1 ));
}

alias 'cd..'='cd_up'
