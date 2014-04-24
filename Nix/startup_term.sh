#! /bin/bash

## handle parameters
handle_params( ) {
  for param in $*
  do
    ## force re-download and setup
    if [ $param = '-f' ]; then
      rm -f ~/.vim/autoload/pathogen.vim
      rm -rf ~/.vim/bundle/nerdtree
      rm -f ~/.vimrc
      rm -rf ~/.oh-my-zsh
    fi
    
    ## help
    if [ $param = '-h' ]; then
      echo 'startup_term.sh [-f] [-h]'
      echo '-f : force re-download and setup'
      echo '-h : help'
      exit
    fi
    
    ## append zshrc
    if [ $param = 'append_zshrc' ]; then
      append_zshrc="true"
    fi
  done
}

## check time stamps of two files
check_time_stamp( ) {
  if [ $(uname) = 'Darwin' ]; then
    file1_ts=`stat -f "%m" $1`
    file2_ts=`stat -f "%Y" $1`
  else
    file1_ts=`stat -c "%Y" $1`
    file2_ts=`stat -c "%Y" $1`
  fi

  if [ $file1_ts -ge $file2_ts ]; then
    return $1
  else
    return $2
  fi
}

append_zshrc="false"
handle_params $*

### vim
##  pathogen
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  echo 'Installing pathogen...'
  mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

## nerdtree
if [ ! -d ~/.vim/bundle/nerdtree ]; then
  echo 'Installing nerdtree...'
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
fi

## vimrc
# vimrc="~/.vimrc" # readlink -f
if [ ! -f ~/.vimrc ]; then
  echo 'Copying vimrc ...'
  curl -Sso ~/.vimrc https://raw.github.com/dnath/config/master/Nix/.vimrc
# else
  # tmp='_tmp'
  # vimrc_tmp="$vimrc$tmp"
  # curl -Sso $vimrc_tmp https://raw.github.com/dnath/config/master/Nix/.vimrc
  # file=check_time_stamp $vimrc $vimrc_tmp
fi  

### zsh 
##  oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  echo 'Installing oh-my-zsh...'
  curl -L "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" | sh
fi

## oh-my-zsh theme
if [ ! -f ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme ]; then
  echo 'Copying my modified version of agnoster...'
  curl -Sso ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme \
    https://raw.github.com/dnath/config/master/Nix/agnoster_mod.zsh-theme
  if [ -f ~/.zshrc ]; then
    sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster_mod"' ~/.zshrc
  else
    echo 'Unable to set zsh theme as .vimrc is missing !'
  fi
fi

## add to zshrc
if [ -f ~/.zshrc  ]; then
  if [ $append_zshrc = "true" ]; then
    curl -Sso zshrc_tmp https://raw.github.com/dnath/config/master/Nix/.zshrc
    cat zshrc_tmp >> ~/.zshrc
    rm -f zshrc_tmp
  fi
fi

