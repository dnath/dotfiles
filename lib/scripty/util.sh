SCRIPTY_LIB="${HOME}/lib/scripty"

source ${SCRIPTY_LIB}/logging.sh || echo "Could not source ${SCRIPTY_LIB}//logging.sh!"

function source_if_exists() {
  if [ -f $1 ]; then
    source $1 || log::error "Could not source file $1!"
  else 
    log::error "Could not find the file $1!"
  fi
}

# Is current terminal ssh-ed into a remote machine ?
function is_ssh() {
  test -z "${DISPLAY}"
  return $?
}
