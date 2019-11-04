# dotfiles

## Pre-requisites

1.  Set zsh as default.

    ```shell
    chsh -s $(which zsh)
    ```

1.	Install git.
1.	Install sublime.

    *   Install packagecontrol.

        https://packagecontrol.io/installation



1.  Install vim.

1.  Install powerline fonts.

    https://github.com/powerline/fonts

1.  Install pip.
1.  Install powerline.
1.  Install stow.

### For MacOS

1.  Install brew

    ```shell
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

1.  Brew packages

    *   ```shell
        brew install stow
        brew tap bazelbuild/tap
        brew tap-pin bazelbuild/tap
        brew install bazelbuild/tap/bazel
        ```


### For Linux

TODO(dnath): Add them.

### Installation

```shell
cd ${REPO}
stow -vt ~ .
```

To delink:

```shell
cd ${REPO}
stow -Dvt ~ .
```


## Setup Scripts


### setup.sh

To run setup.sh, execute the following from the terminal.

`$ curl -SsL "https://raw.githubusercontent.com/dnath/config/master/setup.sh" | bash`

NOTE: `yum` / `apt-get` is determined at runtime.


### setup\_term.sh

For running setup\_term.sh, execute the following from the terminal.

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/setup_term.sh" | bash`

Use `force` option to delete previous configurations.
Use `append_zshrc` option to append customizations to .zshrc.

**Note:** *Use `-s` with bash when piping the script with `curl`.*

### setup\_vim.sh

For running setup\_vim.sh, execute the following from the terminal.

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/setup_vim.sh" | sh`


### setup\_pymodules.sh

For running setup\_pymodules.sh, execute the following from the terminal.

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/setup_pymodules.sh" | bash`

### hterm

https://github.com/wernight/powerline-web-fonts


## TODO

1.  Autoformatter for py, c, cc, js, java, html, md, go, rb.
1.  Preview for md
1.  Auto test and presubmit
1.  go links


