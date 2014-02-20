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

echo 'Installing curl...'
sudo $cmd -y install curl

echo 'Installing vim...'
sudo $cmd -y install vim

echo 'Installing git...'
sudo $cmd -y install git

echo 'Installing openjdk-7-jdk icedtea-7-plugin...'
sudo $cmd -y install openjdk-7-jdk icedtea-7-plugin

echo 'Installing zsh...'
sudo $cmd -y install zsh
echo 'Setting zsh as default shell... [Relogin to get zsh]'
sudo chsh -s "$(which zsh)"


