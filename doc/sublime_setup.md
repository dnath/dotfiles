# Sublime Setup

## Pre-requisites

Update and install `wget`:

```shell
sudo apt update
sudo apt-get install --assume-yes wget
```

## Installation

For linux:

1. Install the GPG key:

    ```shell
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    ```

1. Ensure apt is set up to work with https sources:

    ```shell
    sudo apt-get install apt-transport-https
    ````

1. Install the stable version

    ```shell
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text
    ```

Ref: <https://www.sublimetext.com/docs/3/linux_repositories.html>

## Extra packages

1. Install `packagecontrol`, following <https://packagecontrol.io/installation>.

TODO(dnath): Fill in list of packages to install.
