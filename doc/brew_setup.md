# Homebrew Setup

## Install `brew`

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ref: <https://brew.sh/>

## Install essential `brew` packages

```shell
brew install wget stow vim tree
brew install git python jupyterlab
```

## More optional `brew` packages

```shell
# Developer helpers
brew tap bazelbuild/tap
brew tap-pin bazelbuild/tap
brew install bazelbuild/tap/bazel

# Download helpers
brew install youtube-dl ffmpeg
```

## Optional Mac Apps

```shell
brew install texmaker meld
```

NOTE: Delete previous apps installed if there is conflict.

## FAQs

### How to update `brew` ?

```shell
# Updates package defs
brew update

# Upgrade everything
brew upgrade
```

### How to get a list of installed `brew` packages ?

```shell
brew list
```

### How to uninstall `brew` ?

Ref: <https://github.com/homebrew/install#uninstall-homebrew>
