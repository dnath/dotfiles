#!/bin/sh

##############################################################################
#
# Global Vars
#
##############################################################################

PY_MAJOR_MIN=2
PY_MINOR_MIN=7

TMP_DIR='pymod_repo_tmp'
REPO_DIR='repo'

getpip_url='https://bootstrap.pypa.io/get-pip.py'

numpy_git_url='https://github.com/numpy/numpy'
numpy_git_tag='v1.8.1'

scipy_git_url='https://github.com/scipy/scipy'
scipy_git_tag='v0.14.0'

matplotlib_git_url='https://github.com/matplotlib/matplotlib'
matplotlib_git_tag='v1.3.1'

# ipython
# pandas

sympy_git_url='https://github.com/sympy/sympy'
sympy_git_tag='sympy-0.7.5'

# nose


##############################################################################
#
# Functions
#
##############################################################################

install_mac_dependencies () {
  if [[ -z "$(command -v gcc)" ]]; then
    echo 'Installing gcc from brew...'
    echo
    brew install gcc
    echo
    echo 'DONE'
  fi
}

install_pymod_from_git () {
  echo
  echo "====================================================================="
  py_module=$1
  echo "Python Module: $py_module"
  git_url=$2
  echo "Repo: $git_url"
  git_tag=$3
  echo "Tag: $git_tag"
  echo "====================================================================="

  dir=`pwd`
  mkdir -p "$TMP_DIR"
  cd "$TMP_DIR"
  git clone "$git_url" "$REPO_DIR"
  cd "$REPO_DIR"
  git checkout $git_tag

  echo "Running setup.py install for $py_module..."
  echo
  sudo python setup.py install > "../$py_module.install.log" 2>&1 \
    && tail -100 "../$py_module.install.log" 
  echo
  echo 'DONE'
  echo

  cd "$dir"
  sudo rm -rf "$TMP_DIR"
}

install_py_modules () {
  ## numpy
  install_pymod_from_git "numpy" "$numpy_git_url" "$numpy_git_tag"

  ## numpy
  install_pymod_from_git "scipy" "$scipy_git_url" "$scipy_git_tag"

  ## numpy
  install_pymod_from_git "matplotlib" "$matplotlib_git_url" "$matplotlib_git_tag"

  ## ipython
  sudo pip install ipython

  ## pandas
  sudo pip install pandas

  ## nose
  sudo pip install nose   
}

run () {
  ver=`python -V 2>&1`
  read -ra tmp <<< "$ver"
  # echo ${tmp[1]}

  IFS='.' read -ra py_ver <<< "${tmp[1]}"
  py_major_ver=${py_ver[0]}
  py_minor_ver=${py_ver[1]}

  # echo $py_major_ver
  # echo $py_minor_ver

  if [[ $py_major_ver -ge $PY_MAJOR_MIN  
    && $py_minor_ver -ge $PY_MINOR_MIN ]]; then

    ## pip
    if [ -z "$(command -v pip)" ]; then
      echo 'Installing pip...'
      curl -L "$getpip_url" | sudo python
    fi

    ## install python modules
    install_py_modules

  else
    echo
    echo "Current Python version = $py_major_ver.$py_minor_ver" \
      "< supported version $PY_MAJOR_MIN.$PY_MINOR_MIN"
    echo "Exiting..."
    exit
  fi
}

rumLinux () {
  if [ -n "$(command -v yum)" ]; then
    pkg_manager='yum'
  elif [ -n "$(command -v apt-get)" ]; then
    pkg_manager='apt-get'
  else
    echo 'Failed to find yum/apt-get in Linux !!'
    exit
  fi  
  
  sudo $pkg_manager install python-numpy python-scipy python-matplotlib \
                            ipython ipython-notebook python-pandas \
                            python-sympy python-nose
}

##############################################################################
#
# Main Script
#
##############################################################################

osname=`uname` 
if [[ "$osname" = 'Darwin' ]]; then
  # Mac OS X
  install_mac_dependencies
  run
elif [[ "$osname" = 'Linux' ]]; then
  # Linux
 runLinux
else
  echo
  echo "Unsupported OS '$osname'"
  echo "Exiting..."
  exit
fi

