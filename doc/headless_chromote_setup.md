# Headless Chrome Remote Desktop Setup

## Pre-requisites

Update package lists and install `wget`:

```shell
sudo apt update
sudo apt-get install --assume-yes wget
```

Additionally, consider running:

```shell
sudo apt upgrade -y
```

## Install Chromote in remote machine

1. On the remote machine, install chromote:

    ```shell
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    ```

    Follow-up, if needed:

    ```shell
    sudo apt install --assume-yes --fix-broken
    ```

1. \[Optional\] Add your user account to the Linux group:

    ```shell
    sudo usermod -a -G chrome-remote-desktop $USER
    ```

    Most likely not needed anymore.

1. On your local laptop browser, open <https://remotedesktop.google.com/headless>.
    Then follow the steps to set up another computer. You would probably copy
    the relevant command to your remote shell, similar to this:

    ```shell
    DISPLAY= /opt/google/chrome-remote-desktop/start-host \
        --code="4/xxxxxxxxxxxxxxxxxxxxxxxx" \
        --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
        --name=
    ```

### Install a desktop GUI environment in remote machine

You may want to follow the steps in
<https://victorleungtw.medium.com/install-ubuntu-desktop-on-aws-instance-with-chrome-remote-desktop-3beb30755379>
to install a desktop GUI environment in the remote linux machine..

Additional steps for it are:

1. Install Xfce as it performs the best without fancy animations over a slow network.

    ```shell
    sudo apt install -y xfce4 xfce4-goodies dbus-x11
    ```

1. Configure Chrome Remote Desktop to use Xfce by default:

    ```shell
    sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
    ```

1. Install xscreensaver as an alternative to the default Xfce locker, which doesn’t work with remote desktop:

    ```shell
    sudo apt install --assume-yes xscreensaver
    ```

1. Disable display manager as there is no display connected:

    ```shell
    sudo systemctl disable lightdm.service
    ```

## Optional Steps

### Install Chrome browser

```shell
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

## FAQs

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

* Traffic on TCP port `443` (HTTPS)
* Traffic on TCP and UDP on port `3478` (STUN)

Ref: <https://support.google.com/chrome/answer/1649523>
