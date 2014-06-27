# .config
 
Various Configuration or Setup Files for \*Nix systems

*e.g. dotfiles* 


## setup.sh

To run setup.sh, execute the following from the terminal.

`$ curl -SsL "https://raw.githubusercontent.com/dnath/config/master/startup.sh" | sh`

**Note:** *`yum` / `apt-get` is determined at runtime.*


## setup\_term.sh

For running setup\_term.sh, execute the following from the terminal.

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/setup_term.sh" | bash`

Use `force` option to delete previous configurations.
Use `append_zshrc` option to append customizations to .zshrc.

**Note:** *Use `-s` with bash when piping the script with `curl`.*


## setup\_pymodules.sh

For running setup\_pymodules.sh, execute the following from the terminal.

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/setup_pymodules.sh" | sh`
