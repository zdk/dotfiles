ZDK's dotfiles
==============

    ./setup.sh              install
    ./setup.sh --dry-run    print what would change, touch nothing
    ./setup.sh --prune      install, then drop links setup.sh no longer makes

Safe to re-run: links already pointing at the right place are left alone.

Layout
------

    home/        linked into ~/ on every machine
    darwin/      linked into ~/ on macOS
    linux/       linked into ~/ on Linux

    attic/       kept for reference, not linked
    imported/    applied by hand through an app
    scripts/     run on demand

Paths inside the linked trees mirror `$HOME`, so `home/.gitconfig` becomes
`~/.gitconfig` and `darwin/.config/raycast/scripts` becomes
`~/.config/raycast/scripts`.
