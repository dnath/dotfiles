#!/usr/bin/env zsh

# Usage:
#
# wget https://raw.githubusercontent.com/dnath/dotfiles/master/bin/install_chromote.sh
# zsh install_chromote.sh

# Regular foreground colors for zsh   
SC_COLOR_red='\e[0;31m'
SC_COLOR_green='\e[0;32m'
SC_COLOR_yellow='\e[0;33m'

function log::error() {
  echo "${SC_COLOR_red}$@${SC_COLOR_reset}"
}
function log::fatal() {
  log::error "$@"
  exit -1
}
function log::warning() {
  echo "${SC_COLOR_yellow}$@${SC_COLOR_reset}"
}
function log::info() {
  echo "${SC_COLOR_green}$@${SC_COLOR_reset}"
}

function print_help() {
  package=`basename "$0"`
  echo "$package - Install chromote and dependencies."
  echo " "
  echo "$package [options]"
  echo " "
  echo "options:"
  echo "-p, --pin=PIN       specify pin to use"
  echo "-c, --code=CODE     specify code to use"
}

function parse_arguments() {
  while test $# -gt 0; do
    case "$1" in
      -h|--help)
        print_help
        exit 0
        ;;
      -p)
        shift
        if test $# -gt 0; then
          PIN=$1
        else
          log::fatal "no pin specified"
        fi
        shift
        ;;
      --pin*)
        PIN=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
      -c)
        shift
        if test $# -gt 0; then
          CODE=$1
          log::fatal "no code specified"
        fi
        shift
        ;;
      --code*)
        CODE=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
      *)
        break
        ;;
    esac
  done
}

function validate_arguments() {
  if [[ "${PIN}" == "" ]]; then
    log::fatal "-p/--pin is required!"
  fi

  if [[ "${CODE}" == "" ]]; then
    log::fatal "-p/--pin is required!"
  fi

  OS=`uname`
  if [[ "${OS}" != 'Linux' ]]; then
    log::fatal "Only Linux is supported!"
  fi
}

funtion main() {
  parse_arguments
  validate_arguments

  sudo apt update

  log::info "Installing wget..."
  sudo apt-get install --assume-yes wget
  [[ $? -eq 0 ]] || log::error "wget installation failed!"

  log::info "Installing chromote..."
  wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
  sudo dpkg --install chrome-remote-desktop_current_amd64.deb
  sudo apt install --assume-yes --fix-broken
  [[ $? -eq 0 ]] || log::error "chromote installation failed!"

  sudo usermod -a -G chrome-remote-desktop $USER

  log::info "Registering chromote with pin: ${PIN} and code "${CODE}"..."
  DISPLAY= /opt/google/chrome-remote-desktop/start-host \
    --code="${CODE}" \
    --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
    --name=$(hostname) \
    --pin="${PIN}"
  [[ $? -eq 0 ]] || log::error "chromote installation failed!"

  log::info "Installing chrome browser..."
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  [[ $? -eq 0 ]] || log::error "chrome browser installation failed!"

  log::info "Done."
}

main "$#"
