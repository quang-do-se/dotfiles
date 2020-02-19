
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

SET="\[\e[0m\]"
RESET="\[\e[m\]"

BG_RED="\[\e[41m\]"
BG_BRIGHT_RED="\[\e[101m\]"
BG_BLUE="\[\e[44m\]"
BG_YELLOW="\[\e[43m\]"

FG_BLACK="\[\e[30m\]"
FG_GREEN="\[\e[1;32m\]" # 1; bold version of that color
FG_BLUE="\[\e[1;34m\]" 
FG_CYAN="\[\e[1;36m\]"
FG_BRIGHT_GREEN='\[\e[0;92m\]'
FG_YELLOW='\[\e[0;93m\]'

FG_BOLD="\[\e[1m\]"
FG_BOLD_RESET="\[\e[21m\]"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="${SET}${FG_GREEN}\u@\h${RESET}${FG_BLUE} \w${FG_YELLOW}\$(parse_git_branch) ${RESET}\n${FG_CYAN}\$${RESET} "

#-------------------------------------------------

#-------------------------------------------------
# Retake Ctrl-S in terminal
stty stop ^j
#-------------------------------------------------
# END

function cd_up() {
  cd $(printf "%0.s../" $(seq 1 $1 ));
}

alias 'cd..'='cd_up'
