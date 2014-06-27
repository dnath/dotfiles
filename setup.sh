#!/bin/sh

###############################################################################
# setup.sh
#
# Dibyendu Nath
# dev.nath.cs@gmail.com
###############################################################################

###############################################################################
# Functions
#
###############################################################################

## install package
install_package () {
  pkg_name="$1"
  
  echo
  echo '======================================================================'
  echo " Package: $pkg_name" 
  echo '======================================================================'
  
  if [ -z "$(command -v "pkg_name")" ]; then
    echo "Installing $pkg_name..."
    sudo $PKG_MANAGER -y install $pkg_name
  fi

  echo
  echo 'DONE'
}

# common to Nix
run_common () {
  install_package "curl"
  install_package "gcc"
  install_package "git"
  install_package "vim"
  install_package "python"
}

# Mac OSX
run_mac () {
  run_common
}

# Linux
run_linux () {
  ## build-essential : make
  if [ -z "$(command -v make)" ]; then
    echo 'Installing build-essential...'
    sudo $cmd -y install build-essential
  fi
  
  run_common

  ### javac
  # if [ -z "$(command -v javac)" ]; then
  #   echo 'Installing openjdk-7-jdk icedtea-7-plugin...'
  #   sudo $PKG_MANAGER -y install openjdk-7-jdk icedtea-7-plugin
  # fi
}

if [ -z "$(command -v zsh)" ]; then
  echo 'Installing zsh...'
  sudo $cmd -y install zsh
fi
echo 'Setting zsh as default shell... [Relogin to get zsh]'
sudo chsh -s "$(which zsh)"


###############################################################################
# Main Script
#
###############################################################################

OSNAME=$(uname)

if [[ "$OSNAME" = 'Linux' ]]; then
  # Linux
  if [[ -n "$(command -v yum)" ]]; then
    PKG_MANAGER='yum'
  elif [[ -n "$(command -v apt-get)" ]]; then
    PKG_MANAGER='apt-get'
  else
    echo 'Failed to find yum/apt-get in Linux !!'
    exit
  fi

elif [[ "$OSNAME" = 'Darwin' ]]; then
  # Mac OSX
  if [[ -n "$(command -v brew)" ]]; then
    PKG_MANAGER='brew'
  else
    echo 'Failed to find brew in Mac OSX !!'
    exit
  fi
fi

## calling startup_term.sh 
echo
echo 'Calling startup_term.sh ...'
curl -SsL \
  "https://raw.githubusercontent.com/dnath/config/master/setup_term.sh" | \
  bash -s append_zshrc
