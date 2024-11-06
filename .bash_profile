# ---------------------------------------------------------------------------
# enviroment variables
# ---------------------------------------------------------------------------
# common
export LANG=en_US.UTF-8
export EDITOR=vim
export PAGER=less
export SHELL=bash

# XDG Base Directory
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_CACHE_HOME=~/.cache

# less
export LESS='-g -i -M -R -S -W -z-4 -x4'
export LESSHISTFILE=-

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
# for uv (python package manager)
# See https://docs.astral.sh/uv/
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# ---------------------------------------------------------------------------
# load bashrc
# ---------------------------------------------------------------------------
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
