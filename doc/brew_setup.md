# Homebrew Setup

## Install `brew`

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ref: <https://brew.sh/>

## Install essential `brew` packages

```shell
brew install wget
brew install stow
brew install vim
brew install git
brew install tree
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

## FAQs

### How to update `brew` ?

```shell
brew update
```

### How to get a list of installed `brew` packages ?

```shell
brew list
```
