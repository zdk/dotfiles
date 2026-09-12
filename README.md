ZDK's dotfiles
==============

    ./setup.sh              install
    ./setup.sh --dry-run    print what would change, touch nothing
    ./setup.sh --prune      install, then drop links setup.sh no longer makes

Safe to re-run: links already pointing at the right place are left alone.

Layout
------

`home/` is a literal image of `$HOME`. Every path under it is linked to the
same path in `$HOME`, so the layout of this repo *is* the mapping -- there is
no rename table in `setup.sh` to keep in sync.

    home/.gitconfig            ->  ~/.gitconfig
    home/.config/nvim/         ->  ~/.config/nvim
    home/bin/pb                ->  ~/bin/pb

`darwin/` and `linux/` are overlays of the same shape, of which exactly one
applies. That is why both hold a `.Brewfile` and a `.zshrc.local` instead of
carrying a platform suffix in the filename.

    darwin/.Brewfile           ->  ~/.Brewfile   (on macOS)
    linux/.Brewfile            ->  ~/.Brewfile   (on Linux)

Most directories are linked whole, so a program writing into its own config
directory writes into this repo. The exceptions are listed as `REAL_DIRS` in
`setup.sh`: `.config`, `.config/raycast`, `.gnupg` and `bin` stay real
directories in `$HOME`, linked child by child, because things that are not
ours live in them too -- other programs' state, the gpg keyrings, scripts
from elsewhere.

Not installed
-------------

    attic/       kept for reference, no longer in use
    imported/    applied by hand through an app (iterm2.json)
    scripts/     run on demand (install-astronvim.sh, ...)

Notes
-----

- The three `home/.config/nvim*` configs are linked side by side; pick one
  with `NVIM_APPNAME=nvim-nvchad nvim`, default `nvim` otherwise.
- Raycast needs pointing at `~/.config/raycast/scripts` once, under
  Extensions -> Script Commands -> Add Directories. The symlink keeps that
  registration valid as scripts come and go.
- `~/.Brewfile` is the path `brew bundle --global` reads.
