
### Customizations

# git
alias gsb='git status -sb'
alias glog='git log'
alias gdiff='git diff'
alias grlog='git ref log'

# ls
alias ls='ls -hF -G'
alias ll='ls -l -h'
alias lla='ls -l -a'

# cd
alias ..='cd ..'
alias ...='cd ../..'

# grep
alias grep='grep --color=auto'
alias rgrep='grep -R -n'

# vim as the default editor
export EDITOR=vim

## rails
# for zsh
alias rake='noglob rake'
alias brake='noglob bundle exec rake'

# go
launchctl setenv GOROOT /usr/local/go
launchctl setenv GOPATH /Users/$USER/go

