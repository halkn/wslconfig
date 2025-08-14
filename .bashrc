# ---------------------------------------------------------------------------
# Init
# ---------------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ---------------------------------------------------------------------------
# options
# ---------------------------------------------------------------------------
# HISTORY
export HISTFILE="$XDG_CACHE_HOME/.bash_history"
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend

# TERM
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# bash_completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ---------------------------------------------------------------------------
# alias
# ---------------------------------------------------------------------------
# ls
alias ls="ls --color=auto"
alias ll="ls -lhF"
alias la="ls -lhAF"
alias ltr="ll -tr"

# grep
alias grep='grep --color=auto'

# safety command
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

# human readable for du and df
alias du="du -h"
alias df="df -h"

# useful
alias ..='cd ..'
alias path='echo $PATH | tr ":" "\n"'
alias bs="source ~/.bashrc"
alias :q="exit"

# ---------------------------------------------------------------------------
# tools
# ---------------------------------------------------------------------------
# mise
if type mise > /dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# uv
if type uv > /dev/null 2>&1; then
  eval "$(uv generate-shell-completion basg)"
fi

# ---------------------------------------------------------------------------
# prompt
# ---------------------------------------------------------------------------
if type starship > /dev/null 2>&1; then
  eval "$(starship init bash)"
fi
