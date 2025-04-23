#!/usr/bin/env zsh

CURRENT_PATH="$0:a:h"

function link_dot () {
  ln -svf "$CURRENT_PATH/${1}" "${ZDOTDIR:-$HOME}/.${1}"
}

# Add any dot file
files=('zshrc' 'zpreztorc' 'config')

echo "Linking..."
setopt EXTENDED_GLOB
for f in $files; do
  link_dot "$f"
done
echo "Done!"

# Install astro neovim
# ./install-astronvim.sh

# Alacrity theme
# git submodule update --init --recursive
