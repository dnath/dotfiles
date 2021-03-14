# dotfiles

## Pre-requisites

1.  Set zsh as default.

    ```shell
    chsh -s $(which zsh)
    ```

1.	Install git.
1.  Install wget.
1.	Install sublime.
1.  Install sublime packages.

    *   Install packagecontrol.

        https://packagecontrol.io/installation

1.  Install vim.

1.  Install [powerline fonts](https://github.com/powerline/fonts)

1.  Install pip.
1.  Install powerline.

    ```shell
    pip install powerline-status
    ```

## Installation

### For MacOS

1.  Install brew

    ```shell
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

1.  Get __brew__ packages

    ```shell
    brew install stow
    brew tap bazelbuild/tap
    brew tap-pin bazelbuild/tap
    brew install bazelbuild/tap/bazel
    ```

1.  Install __dotfiles__

    Before installing you may want to cleanup any straggler `.*rc` files like:

    ```shell
    rm -f .bashrc .zshrc
    ```

    To clone and install dotfiles:

    ```shell
    git clone --recursive git@github.com:dnath/dotfiles.git
    cd dotfiles
    stow -vt ~ .
    ```

### For Linux

TODO(dnath): Add more custom packages, if any.

1.  Install stow

    ```shell
    sudo apt-get install stow
    ```

1.  Install __dotfiles__

    Before installing you may want to cleanup any straggler `.*rc` files like:

    ```shell
    rm -f .bashrc .zshrc
    ```

    To clone and install dotfiles:

    ```shell
    git clone --recursive git@github.com:dnath/dotfiles.git
    cd dotfiles
    stow -vt ~ .
    ```

## Optional Steps

### Install headless chrome remote desktop in Linux

1. On the remote machine, install chromote:

    ```shell
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    ```

1.  Add your user account to the Linux group:

    ```shell
    sudo usermod -a -G chrome-remote-desktop $USER
    ```

1.  On your local laptop browser, open https://remotedesktop.google.com/headless.
    Then follow the steps to set up another computer. You would probably copy
    the relecant command to your remote shell, similar to this:

    ```shell
    DISPLAY= /opt/google/chrome-remote-desktop/start-host \
        --code="4/xxxxxxxxxxxxxxxxxxxxxxxx" \
        --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
        --name=
    ```

For installing chromote in an Ubuntu EC2 instance, follow the steps in
https://victorleungtw.medium.com/install-ubuntu-desktop-on-aws-instance-with-chrome-remote-desktop-3beb30755379
which involves installation of a desktop GUI environment.

Additional steps for it are:

1.  Install Xfce as it performs the best without fancy animations over a slow network.

    ```shell
    sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-
    ```
1.  Configure Chrome Remote Desktop to use Xfce by default:

    ```shell
    sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
    ```

1.  Install xscreensaver as an alternative to the default Xfce locker, which doesn’t work with remote desktop:

    ```shell
    sudo apt install --assume-yes xscreensaver
    ```

1.  Disable display manager as there is no display connected:

    ```shell
    sudo systemctl disable lightdm.service
    ```

## FAQs

###  How to delink dotfiles?

```shell
cd ${REPO}
stow -Dvt ~ .
```

### How to restart chromote?

For Linux:

```shell
sudo service chrome-remote-desktop restart
```

For MacOS:

```shell
launchctl start org.chromium.chromoting
```

### What ports are needed for chromote?

*   Traffic on TCP port 443 (HTTPS)
*   Traffic on TCP and UDP on port 3478 (STUN)

Ref: https://support.google.com/chrome/answer/1649523


## TODOs

1.  Autoformatter for py, c, cc, js, java, html, md, go, rb.
1.  Preview for md
1.  Auto test and presubmit
1.  short links


