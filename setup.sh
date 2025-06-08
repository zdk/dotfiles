#!/usr/bin/env zsh

CURRENT_PATH="$0:a:h"

function link_dot () {
  ln -svf "$CURRENT_PATH/${1}" "${ZDOTDIR:-$HOME}/.${1}"
}

function unlink_dot () {
  rm -f "${ZDOTDIR:-$HOME}/.${1}"
}

# Add any dot file
files=('zshrc' 'zpreztorc' 'config')

echo "Linking..."
setopt EXTENDED_GLOB
for f in $files; do
  unlink_dot "$f"
  link_dot "$f"
done
echo "Done!"


# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file=./Brewfile

# Install astro neovim
./install-astronvim.sh
nvim -c 'AstroUpdate' -c 'quit'
