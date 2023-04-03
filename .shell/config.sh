SCRIPTY_LIB="${HOME}/lib/scripty"
source "${SCRIPTY_LIB}/logging.sh" || echo "Cannot source ${SCRIPTY_LIB}/logging.sh!"

# Detect current OS and set vars.
OS=
IS_MACOS=0
IS_LINUX=0
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
    log::error 'Could not detect current Linux distribution!'
  fi
else
  log::error 'Could not detect current OS!'
fi

source "${SCRIPTY_LIB}/util.sh" || log::fatal "Cannot source ${SCRIPTY_LIB}/util.sh!"

# Preferred editor for local vs remote sessions.
if is_ssh; then
  export EDITOR='vim'  # alternative: nano
else
  export EDITOR='vim'  # alternative: gvim
fi
