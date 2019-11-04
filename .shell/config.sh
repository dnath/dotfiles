if [ -f ~/.shell/util.sh ]; then
  source ~/.shell/util.sh
fi

# Preferred editor for local vs remote sessions.
if is_ssh; then
  export EDITOR='vim'  # nano
else
  export EDITOR='vim'  # gvim
fi
