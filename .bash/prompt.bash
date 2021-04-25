force_color_prompt=yes

if [ -n "${force_color_prompt}" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support and let's assume it's compliant with Ecma-48
    # (ISO/IEC-6429). Lack of such support is rare and in such cases setf may
    # be supported instead of setaf.
    color_prompt=yes
  else
    color_prompt=no
  fi
fi

if [ "${color_prompt}" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\d \t \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\d \t \u@\h\:\w\n\$ '
fi

# If this is an xterm, set title to user@host:dir
case "${XTERM}" in
  xterm*|rxvt*)
    PS1="\[e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

unset color_prompt force_color_prompt

# For byobu
# test -r ~/.byobu/prompt && source ~/.byobu/prompt
