# Aliases ----------------------------------------------------------------------
alias z="source $ZDOT_DIR/.zshrc"
alias c="clear"
alias ct="clear; exa --tree"
alias ..="cd .."
alias update='notify.sh "sudo pacman -Syu --noconfirm"'
alias update-yay='notify.sh "yay -Syu"'
alias yy="fc -ln -1 | tr -d '\n' | clipboard.sh copy"
alias open="xdg-open"
alias jo="joshuto"

## git
# alias gc='git clone "$1" && cd $(basename "$1" | sed -e "s/.git//g")'
alias gd='git diff | diff-so-fancy'

## shell scripts
alias n='nvim.sh'
alias t='tmux-startup.sh'
alias gq='gitquick.sh'
alias tab='tab.sh'
alias dot='dotfiles.sh'
alias new='new-script.sh'
#-------------------------------------------------------------------------------

# Functions --------------------------------------------------------------------
function gc() {
	git clone "$1" && cd "$(basename "$1" | sed -e "s/.git//g")"
}
#-------------------------------------------------------------------------------

# Prompt -----------------------------------------------------------------------
PROMPT='%F{#616E88}%n@%m%f %F{#8FAAC9}%~%f%F{#AEC694}$(git_branch)%f %F{#AEC694}>%f '
setopt PROMPT_SUBST
function git_branch() { git symbolic-ref --short HEAD 2> /dev/null | sed -n -e 's/.*/ (&)/p' ;}
#-------------------------------------------------------------------------------

# Vim-Mode ---------------------------------------------------------------------
set -o vi
bindkey -v # Activate vi-mode
KEYTIMEOUT=1 # Remove mode switching delay

# Change cursor shape for different vi modes
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
			echo -ne '\e[1 q'

	elif [[ ${KEYMAP} == main ]] || 
		[[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} = '' ]] ||
		[[ $1 = 'beam' ]]; then
			echo -ne '\e[5 q'
	fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt
preexec() {
	echo -ne '\e[5 q'
}
#-------------------------------------------------------------------------------

# Completion -------------------------------------------------------------------
autoload -U compinit
compinit
zstyle ':completion:*' menu select # colour current tab completion item
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case sensitivity
#-------------------------------------------------------------------------------

# opam configuration
[[ ! -r /home/fritz/.opam/opam-init/init.zsh ]] || source /home/fritz/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
