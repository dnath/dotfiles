# Library for logging

SCRIPTY_LIB="${HOME}/lib/scripty"

source ${SCRIPTY_LIB}/colors.sh || (echo "Cannot source ${SCRIPTY_LIB}/colors.sh!" && exit -1)

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
