# Library for logging

source ${HOME}/lib/scriptalicious/colors.sh || (echo "Cannot source ${HOME}/lib/scriptalicious/colors.sh!" && exit -1)

function log::info {
  print::green "$@"
}

function log::error {
  print::red "$@"
}

function log::fatal {
  log::error "$@"
  exit -1
}