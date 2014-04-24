#! /bin/sh

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

### vim
##  pathogen
if [ -f ~/.vim/autoload/pathogen.vim ]; then
  echo 'Installing pathogen...'
  mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

## nerdtree
if [ ! -d ~/.vim/bundle/nerdtree_plugin ]; then
  echo 'Installing nerdtree...'
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle
fi

## vimrc
vimrc='~/.vimrc'
if [ ! -f $vimrc ]; then
  curl -Sso $vimrc https://raw.github.com/dnath/config/master/Nix/.vimrc
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

if [ ! -f ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme ]; then
  echo 'Copying my modified version of agnoster'
  curl -Sso ~/.oh-my-zsh/themes/agnoster_mod.zsh-theme \
    https://raw.github.com/dnath/config/master/Nix/agnoster_mod.zsh-theme
fi

