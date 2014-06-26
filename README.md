# config
 
Various Configuration/Setup Files

*e.g. dotfiles* 

## \*Nix

For \*nix systems

### setup\_term.sh

For running setup\_term.sh

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/Nix/setup_term.sh" | bash`

Use `force` option to delete previous configurations.
Use `append_zshrc` option to append customizations to .zshrc.

***Note:** Use `-s` with bash when piping the script with `curl`.*


### pymod\_setup.sh

For running pymod\_setup.sh

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/Nix/pymod_setup.sh" | sh`



## Linux

To run startup.sh.

`$ curl -SsL "https://raw.githubusercontent.com/dnath/config/master/linux/startup.sh" | sh`

***Note:** `yum` / `apt-get` is determined at runtime.*
