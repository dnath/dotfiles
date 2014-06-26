#! /bin/bash

################################################################################
# term_setup.sh
#
# Dibyendu Nath
# dev.nath.cs@gmail.com
#
################################################################################

################################################################################
# Global Variables
#
################################################################################

# vundle_url="https://github.com/gmarik/vundle.git"
pathogen_url="https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
nerdtree_git_url="https://github.com/scrooloose/nerdtree.git"


pystartup_url="https://raw.githubusercontent.com/dnath/config/master/Nix/pystartup"
ohmyzsh_script_url="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"


zsh_url="https://raw.githubusercontent.com/dnath/config/master/Nix/zshrc"

vimrc_url="https://raw.githubusercontent.com/dnath/config/master/Nix/vimrc"
agnoster_mod_url="https://raw.githubusercontent.com/dnath/config/master/Nix/agnoster_mod.zsh-theme"

append_zshrc="false"

################################################################################
# Functions
#
################################################################################

## handle parameters
handle_params () {
  for param in $*
  do
    ## force re-download and setup
    if [[ $param = 'force' || $param = '-f' ]]; then
      echo 'Removing old terminal config... '
      rm -f ~/.vim/autoload/pathogen.vim
      rm -rf ~/.vim/bundle/nerdtree
      rm -f ~/.vimrc
      rm -rf ~/.oh-my-zsh
      rm -f ~/.pystartup
      rm -f ~/.pyhistory
    fi
    
    ## help
    if [[ $param = 'help' || $param = '-h' ]]; then
      echo 'startup_term.sh [-f] [-h]'
      echo '-f : force re-download and setup'
      echo '-h : help'
      exit
    fi
    
    ## append zshrc
    if [[ $param = 'append_zshrc' || $param = '-z' ]]; then
      append_zshrc="true"
    fi
  done
}

## check time stamps of two files
check_time_stamp () {
  if [ $(uname) = 'Darwin' ]; then # for OSX
    file1_ts=`stat -f "%m" $1`
    file2_ts=`stat -f "%Y" $1`
  else                             # for Linux
    file1_ts=`stat -c "%Y" $1`
    file2_ts=`stat -c "%Y" $1`
  fi

  if [ $file1_ts -ge $file2_ts ]; then
    return $1
  else
    return $2
  fi
}

## vim plugins
install_vim_plugins () {
  echo
  echo "======================================================================"
  echo "Setting up vim..."
  echo "======================================================================"
  ##  pathogen
  if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
    echo 'Installing pathogen...'
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -Sso ~/.vim/autoload/pathogen.vim $pathogen_url
  fi

  ## nerdtree
  if [ ! -d ~/.vim/bundle/nerdtree ]; then
    echo 'Installing nerdtree...'
    git clone $nerdtree_git_url  ~/.vim/bundle/nerdtree
  fi

  ## vimrc
  # vimrc="~/.vimrc" # readlink -f
  if [ ! -f ~/.vimrc ]; then
    echo 'Copying vimrc ...'
    curl -Sso ~/.vimrc $vimrc_url
  fi  
}

## python modules, config
setup_python () {
  echo
  echo "======================================================================"
  echo "Setting up python..."
  echo "======================================================================"

  ## add .pystartup
  if [ ! -f ~/.pystartup ]; then
    echo 'Adding ~/.pystartup...'
    curl -Sso ~/.pystartup $pystartup_url
    if [[ -z $(grep '^export PYTHONSTARTUP=~/.pystartup' ~/.zshrc) ]]; then
      echo 'Adding PYTHONSTARTUP env var...'
      echo '# python startup' >> ~/.zshrc
      echo 'export PYTHONSTARTUP=~/.pystartup' >> ~/.zshrc
    fi
  fi
}

## zsh config
setup_zsh () {
  echo
  echo "======================================================================"
  echo "Setting up zshrc..."
  echo "======================================================================"
  
  ##  oh-my-zsh
  if [ ! -d ~/.oh-my-zsh ]; then
    echo 'Installing oh-my-zsh...'
    curl -SsL $ohmyzsh_script_url | sh

    ## forcibly append zshrc
    append_zshrc="true"
  fi

  ## oh-my-zsh theme
  if [ ! -f ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme ]; then
    echo 'Copying modified version of agnoster...'
    curl -Sso ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme $agnoster_mod_url
    if [ -f ~/.zshrc ]; then
      sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster_mod"' ~/.zshrc
    else
      echo 'Unable to set zsh theme as .vimrc is missing !'
    fi
  fi

  ## append to zshrc
  if [ $append_zshrc = "true" ]; then
    if [ -f ~/.zshrc  ]; then
      echo 'Appending to .zshrc ...'
      curl -Sso zshrc_tmp $zshrc_url
      cat zshrc_tmp >> ~/.zshrc
      rm -f zshrc_tmp
    fi
  fi
}



################################################################################
# Main Script
#
################################################################################

handle_params $*

### vim
install_vim_plugins

### zsh
setup_zsh

### python
setup_python

