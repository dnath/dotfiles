#!/bin/sh

###############################################################################
# setup.sh
#
# Dibyendu Nath
# dev.nath.cs@gmail.com
###############################################################################

###############################################################################
# Global Vars
#
###############################################################################

setup_term_url='https://raw.githubusercontent.com/dnath/config/master/setup_term.sh'

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
  
  if [[ -z "$(command -v $pkg_name)" ]]; then
    echo "Installing $pkg_name..."
    sudo $PKG_MANAGER -y install $pkg_name
  else
    echo "$pkg_name already installed."
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

  install_package "zsh"
  echo
  echo 'Setting zsh as default shell... [Relogin to get zsh]'
  sudo chsh -s "$(which zsh)" $USER
}

# Mac OSX
run_mac () {
  run_common
}

# Linux
run_linux () {
  ## build-essential : make
  if [[ -z "$(command -v make)" ]]; then
    echo 'Installing build-essential...'
    sudo $PKG_MANAGER -y install build-essential
  fi
  
  run_common
  
  ### openssh server
  # install_package "openssh-server"

  ### javac
  # if [ -z "$(command -v javac)" ]; then
  #   echo 'Installing openjdk-7-jdk icedtea-7-plugin...'
  #   sudo $PKG_MANAGER -y install openjdk-7-jdk icedtea-7-plugin
  # fi
}


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

  run_linux

elif [[ "$OSNAME" = 'Darwin' ]]; then
  # Mac OSX
  if [[ -n "$(command -v brew)" ]]; then
    PKG_MANAGER='brew'
  else
    echo 'Failed to find brew in Mac OSX !!'
    exit
  fi

  run_mac

fi

## calling setup_term.sh 
echo
echo 'Calling setup_term.sh ...'
curl -SsL "$setup_term_url" | bash -s append_zshrc

