source /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1

export CLR_PRIMARY='\[\033[01;35m\]'
export CLR_DEFAULT='\[\033[00m\]'
export PS1="[${CLR_PRIMARY}\u \W${CLR_DEFAULT}] \$(__git_ps1 '(%s) ')${CLR_PRIMARY}\\$ ${CLR_DEFAULT}"

if [ -n "$SSH_CONNECTION" ]; then
	PS1="\[\033[1;33m\](\h)${CLR_DEFAULT} ${PS1}"
fi
