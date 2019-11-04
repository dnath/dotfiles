# ~/.bashrc: executed by bash(1) for non-login sheels.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples.

# If not running interactively, don't do anything.
case $- in
  *i*) ;;
    *) return;;
esac

# Don't put duplicate lines or lines starting with space in history.
HISTCONTROL=ignoreboth

# Append to history file, don't overwrite it.
shopt -s histappend

# History length.
HISTSIZE=1000
HISTFILESIZE=2000


# Check the window size after each command and if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# if set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set a variable ro identify the chroot you work (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm, set title to user@host:dir
case "${XTERM}" in
  xterm*|rxvt*)
    PS1="\[e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# Enable programmable completion features (This is not needed as it already
# enabled in /etc/bash.bashrc abd /etc/profile sources /etc/bash/bash.bashrc.)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# More customizatios.
if [ -f ~/.bashrc_more ]; then
  source ~/.bashrc_more
fi
