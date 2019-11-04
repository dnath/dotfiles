is_ssh() {
  test -z "${DISPLAY}"
  return $?
}

source_if_exists() {
  if [ -f $1 ]; then
    source $1
  fi
}


# Detect current OS

OS=
IS_MACOS=
IS_LINUX=
DISTRO=

if which uname &> /dev/null; then
  OS=`uname`
fi

if [[ ${OS} == 'Darwin' ]]; then
  IS_MACOS=1
  DISTRO='macOS'
elif [[ "${OS}" == 'Linux' ]]; then
  IS_LINUX=1
  if [[ -f /etc/gentoo-release ]]; then
    DISTRO='Gentoo'
  elif [[ -f /etc/redhat-release ]]; then
    DISTRO=`awk '{ print $1 }' /etc/redhat-release`
  elif [[ -f /etc/debian_version ]]; then
    DISTRO='Debian'
  else
    echo 'Could not detect current Linux distribution!'
  fi
else
  echo 'Could not detect current OS!'
fi
