#!/bin/bash

################################################################################
# setup_term.sh
#
# Dibyendu Nath
# dev.nath.cs@gmail.com
#
################################################################################

################################################################################
# Global Variables
#
################################################################################

ohmyzsh_sh_url='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'

zshrc_url='https://raw.githubusercontent.com/dnath/config/master/zshrc'
ZSHRC_TMP='zshrc_tmp'

agnoster_mod_url='https://raw.githubusercontent.com/dnath/config/master/agnoster_mod.zsh-theme'

APPEND_ZSHRC="false"

pystartup_url='https://raw.githubusercontent.com/dnath/config/master/pystartup'

setup_vim_url='https://raw.githubusercontent.com/dnath/config/master/setup_vim.sh'

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
      APPEND_ZSHRC="true"
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
  else
    echo '.pystartup already present.'
  fi

  echo
  echo 'DONE'
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
    curl -SsL $ohmyzsh_sh_url | sh

    ## forcibly append zshrc
    APPEND_ZSHRC="true"
  else
    echo 'oh-my-zsh already present.'
  fi

  ## oh-my-zsh theme
  if [ ! -f ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme ]; then
    echo 'Copying modified version of agnoster...'
    curl -Sso ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme "$agnoster_mod_url"
    if [ -f ~/.zshrc ]; then
      if [ "$OSNAME" = 'Linux' ]; then
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster_mod"/' .zshrc
      elif [ "$OSNAME" = 'Darwin' ]
        sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster_mod"/' .zshrc
      else
        echo "OS $OSNAME not supported !"
      fi 
   else
      echo 'Unable to set zsh theme as .vimrc is missing !'
    fi
  else
    echo 'agnoster_mod.zsh-theme already present.'
  fi

  # echo "APPEND_ZSHRC = $APPEND_ZSHRC"
  ## append to zshrc
  if [ "$APPEND_ZSHRC" = "true" ]; then
    if [ -f ~/.zshrc  ]; then
      echo 'Appending to .zshrc ...'
      curl -Sso "$ZSHRC_TMP" "$zshrc_url"
      cat "$ZSHRC_TMP" >> ~/.zshrc
      rm -f "$ZSHRC_TMP"
    fi
  else
    echo 'Not appending to zshrc.'
  fi

  echo
  echo 'DONE'
}


################################################################################
# Main Script
#
################################################################################

OSNAME=$(uname)

handle_params $*

### zsh
setup_zsh

### python
setup_python

### vim
echo
echo 'Calling setup_vim.sh...'
curl -SsL "$setup_vim_url" | sh
