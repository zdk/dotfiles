#!/usr/bin/env zsh

CURRENT_PATH="$0:a:h"

function link_dot () {
  ln -svf "$CURRENT_PATH/${1}" "${ZDOTDIR:-$HOME}/.${1}"
}

# Add any dot file
files=('gitconfig' 'zshrc' 'zpreztorc')

echo "Linking..."
setopt EXTENDED_GLOB
for f in $files; do
  link_dot "$f"
done
echo "Done!"

# ./install-astronvim.sh



