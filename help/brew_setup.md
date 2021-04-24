# Homebrew Setup

## Install `brew`

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Ref: <https://brew.sh/>

## Install essential `brew` packages

```shell
brew install wget
brew install stow
brew install tree
```

## More optional `brew` packages

```shell
brew install git

brew tap bazelbuild/tap
brew tap-pin bazelbuild/tap
brew install bazelbuild/tap/bazel
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
