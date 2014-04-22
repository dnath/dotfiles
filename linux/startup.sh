#! /bin/sh

if [ -n "$(command -v yum)" ]; then
  cmd='yum'
elif [ -n "$(command -v apt-get)" ]; then
  cmd='apt-get'
else
  echo 'Failed to find yum/apt-get !!'
  exit
fi

echo 'Repo Update command = ' $cmd

if [ -z "$(command -v curl)" ]; then
  echo 'Installing curl...'
  sudo $cmd -y install curl
fi

if [ -z "$(command -v vim)" ]; then
  echo 'Installing vim...'
  sudo $cmd -y install vim
fi

if [ -f ~/.vim/autoload/pathogen.vim ]; then
  echo 'Installing pathogen...'
  mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

if [ -d ~/.vim/bundle/nerdtree ]; then
  echo 'Installing nerdtree...'
  cd ~/.vim/bundle
  git clone https://github.com/scrooloose/nerdtree.git
fi

if [ -z "$(command -v git)" ]; then
  echo 'Installing git...'
  sudo $cmd -y install git
fi

if [ -z "$(command -v gcc)" ]; then
  echo 'Installing gcc...'
  sudo $cmd -y install gcc
fi

if [ -z "$(command -v make)" ]; then
  echo 'Installing build-essential...'
  sudo $cmd -y install build-essential
fi

#if [ -z "$(command -v javac)" ]; then
#  echo 'Installing openjdk-7-jdk icedtea-7-plugin...'
#  sudo $cmd -y install openjdk-7-jdk icedtea-7-plugin
#fi

if [ -z "$(command -v zsh)" ]; then
  echo 'Installing zsh...'
  sudo $cmd -y install zsh
fi
echo 'Setting zsh as default shell... [Relogin to get zsh]'
sudo chsh -s "$(which zsh)"

if [ -d ~/.oh-my-zsh ]; then
  echo 'ohmyzsh already installed !'
else
  echo 'Installing oh-my-zsh...'
  curl -L "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" | sh
fi
