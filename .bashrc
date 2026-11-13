# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

# .bashrc.d/hosts/<hostname>.sh
if [ -f ~/.bashrc.d/hosts/"$HOSTNAME".sh ]; then
	. ~/.bashrc.d/hosts/"$HOSTNAME".sh
fi

source /usr/share/git/completion/git-completion.bash


export EDITOR="code --wait"
