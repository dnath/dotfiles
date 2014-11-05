#!/usr/bin/env bash

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

OSLIST=(Darwin Linux)
OSNAME=`uname`
PKG_MNGR=''

###############################################################################
# Functions
#
###############################################################################

init () {
  check_os
  set_package_manager
}

set_package_manager () {
  if [[ $OSNAME = "Darwin" ]]; then
    if [[ -n "$(command -v brew)" ]]; then
      PKG_MNGR="brew"
    else
      if [[ -z "$(command -v ruby)" ]]; then
        echo "Please install ruby! Ruby is required for installing brew."
        exit 1
      else
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      fi
    fi

  elif [[ $OSNAME = "Linux" ]]; then
    if [[ -n "$(command -v apt-get)" ]]; then
      PKG_MNGR="sudo apt-get -y"
    elif [[ -n "$(command -v yum)" ]]; then
      PKG_MNGR="sudo yum -y"
    else
      echo "No supported package manager found! Exiting."
      exit 1
    fi
  else
    echo "Unsupported OS! Exiting."
    exit 1
  fi
}

check_install_pkg () {
  PKG="$1"
  if [[ -z "$(command -v $PKG)" ]]; then
    $PKG_MNGR install $PKG
  fi
}

check_os () {
  IS_SUPPORTED_OS="false"
  for OS in $OSLIST
  do
    if [[ $OS = $OSNAME ]]; then
      IS_SUPPORTED_OS="true"
    fi
  done

  if [[ $IS_SUPPORTED_OS = "false" ]]; then
    echo "OS, '$OSNAME' is not supported! Exiting."
    exit 1
  fi
}

###############################################################################
# Main Script
#
###############################################################################

init
check_install_pkg "curl"
check_install_pkg "git"
check_install_pkg "ruby"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/dnath/config/master/configure.rb)"


