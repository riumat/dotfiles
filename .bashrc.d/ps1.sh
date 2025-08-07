source /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1

export CLR_MAGENTA='\[\033[01;35m\]'
export CLR_DEFAULT='\[\033[00m\]'
export PS1="[${CLR_MAGENTA}\u \W${CLR_DEFAULT}] \$(__git_ps1 '(%s) ')${CLR_MAGENTA}\\$ ${CLR_DEFAULT}"
