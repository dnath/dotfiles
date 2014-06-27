#!/bin/sh

################################################################################
# setup_vim.sh
#
# Dibyendu Nath
# dev.nath.cs@gmail.com
#
################################################################################

################################################################################
# Global Variables
#
################################################################################

vimrc_url="https://raw.githubusercontent.com/dnath/config/master/vimrc"

# vundle_url="https://github.com/gmarik/vundle.git"
pathogen_url="https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
nerdtree_git_url="https://github.com/scrooloose/nerdtree.git"


###############################################################################
# Functions
#
###############################################################################

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

###############################################################################
# Main Script
#
###############################################################################

install_vim_plugins
