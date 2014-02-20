if [ -n "$(command -v yum)" ]; then
  cmd="yum"
elif [ -n "$(command -v apt-get)" ]; then
  cmd="apt-get"
fi

echo 'Installing curl ...'
sudo $cmd -y install curl
echo 'Installing vim ...'
sudo $cmd -y install vim
echo 'Installing git ...'
sudo $cmd -y install git
echo 'Installing openjdk-7-jdk icedtea-7-plugin ...'
sudo $cmd -y install openjdk-7-jdk icedtea-7-plugin
echo 'Installing ZSH ...'
sudo $cmd -y  install zsh
sudo chsh -s "$(which zsh)"


if [ -d ~/.oh-my-zsh ]; then
  echo 'oh-my-zsh already installed ...'
else
  echo 'Installing oh-my-zsh ...'
  curl -L "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" | sh
fi
