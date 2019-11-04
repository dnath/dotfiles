# Setup ${PATH}

if [ ${IS_LINUX} ]; then
  export PATH="$HOME/bin:${PATH}"
elif [ ${IS_MACOS} ]; then
  export PATH="$HOME/bin:${PATH}"
fi
