# Library for color printing.

# Ref: https://stackoverflow.com/questions/16843382/colored-shell-script-output-library

SC_COLOR_reset='\e[0m'    # Text Reset

# Regular foreground colors
SC_COLOR_black='\e[0;30m'
SC_COLOR_red='\e[0;31m'   
SC_COLOR_green='\e[0;32m'
SC_COLOR_yellow='\e[0;33m'
SC_COLOR_blue='\e[0;34m'
SC_COLOR_purple='\e[0;35m'
SC_COLOR_cyan='\e[0;36m'
SC_COLOR_white='\e[0;37m'

function print::red() {
  echo "${SC_COLOR_red}$@${SC_COLOR_reset}"
}

function print::blue() {
  echo "${SC_COLOR_blue}$@${SC_COLOR_reset}"
}

function print::green() {
  echo "${SC_COLOR_green}$@${SC_COLOR_reset}"
}

function print::yellow() {
  echo "${SC_COLOR_yellow}$@${SC_COLOR_reset}"
}