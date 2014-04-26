config
======

Configuration Files for various OSes

Nix
---

For \*nix systems

To run startup\_term.sh

`curl -SsL "https://raw.githubusercontent.com/dnath/config/master/Nix/startup_term.sh" | bash`

Use `force` option to delete previous configurations.
Use `append_zshrc` option to append customizations to .zshrc.

Note: You `-s` with bash when piping the script with `curl`.

linux
-----
To run startup.sh.
`yum` / `apt-get` is determined at runtime.

`$ curl -SsL "https://raw.githubusercontent.com/dnath/config/master/linux/startup.sh" | sh`
