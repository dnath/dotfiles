#!/usr/bin/env zsh

SCRIPTY_LIB="${HOME}/lib/scripty"

source "${SCRIPTY_LIB}/logging.sh" || echo "Cannot source ${SCRIPTY_LIB}/logging.sh!"
source "${SCRIPTY_LIB}/util.sh" || log::fatal "Cannot source ${SCRIPTY_LIB}/util.sh!"

source_if_exists "${HOME}/.shell/config.sh"

if [[ "${IS_LINUX}" = "1" ]]; then
  log::info "Running apt-get..."
  sudo apt-get update
  sudo apt-get upgrade
elif [[ "${IS_MACOS}" = "1" ]]; then
  log::info "Running brew update..."
  brew update
  brew upgrade
fi
