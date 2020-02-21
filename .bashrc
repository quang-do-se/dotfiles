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
alias g="git"

#-------------------------------------------------
# FUNCTION

ev(){
    emacs "$1" --eval '(setq buffer-read-only t)'
}

trash(){
    mv "$@" ~/.Trash/
}

gitgraph(){
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
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

#-------------------------------------------------
# SSH SET UP

# Add ssh to keychain to avoid password prompt everytime
ssh-add -K ~/.ssh/id_rsa &>/dev/null

#-------------------------------------------------
# PROMPT BACKGROUND AND FOREGROUND

SET="\[\e[00m\]"
RESET="\[\e[m\]"

# 01; bold version of that color
# 38;5; foreground color
# 48;5; background color
BG_RED='\[\e[48;5;009m\]'

FG_CYAN="\[\e[01;38;5;087m\]"
FG_BRIGHT_GREEN='\[\e[01;38;5;118m\]'
FG_YELLOW='\[\e[01;38;5;226m\]'
FG_ORANGE='\[\e[01;38;5;214m\]'
FG_WHITE='\[\e[01;38;5;231m\]'

FG_BOLD="\[\e[01m\]"
FG_BOLD_RESET="\[\e[21m\]"

get_git_prompt() {
    git_branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/)*$//' -e 's/* (*\(.*\)/\1/')

    # if there is no branch, don't display anything
    if [ -z ${git_branch} ]
    then
        echo ''
        return 0
    fi
    
    git_status_count=$(git status -s 2>/dev/null | wc -l | sed -e 's/[[:space:]]*//g')

    git_stash_count=$(git stash list 2>/dev/null | wc -l | sed -e 's/[[:space:]]*//g')

    git_conflict_count=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | sed -e 's/[[:space:]]*//g')

    
    if [ ${git_status_count} -eq 0 ]
    then
        git_status_count="${FG_BRIGHT_GREEN}✓" # ✔
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
        git_conflict_count='✗'${git_conflict_count}
    fi

    # squeeze spaces into single space | then remove all trailing spaces
    echo -e " (${git_branch}) ${git_status_count} ${git_stash_count} ${git_conflict_count}" | tr -s " " | sed -e 's/[[:space:]]*$//'
}

set_bash_prompt() {
    PS1="${SET}${FG_WHITE}${BG_RED}\u@\h${RESET}${FG_BRIGHT_GREEN} \w${FG_YELLOW}"$(get_git_prompt)"${RESET}\n${FG_CYAN}\$${RESET} "
}

PROMPT_COMMAND=set_bash_prompt

#-------------------------------------------------

function cd_up() {
    cd $(printf "%0.s../" $(seq 1 $1 ));
}

alias 'cd..'='cd_up'
