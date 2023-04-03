#!/usr/bin/env zsh

source "${HOME}/lib/scriptalicious/logging.sh" || echo "Cannot source ${HOME}/lib/scriptalicious/logging.sh!"
source "${HOME}/lib/scriptalicious/util.sh" || log::fatal "Cannot source ${HOME}/lib/scriptalicious/util.sh!"

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
