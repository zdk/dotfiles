#!/usr/bin/env zsh

CURRENT_PATH="$0:a:h"

function link_dot () {
  ln -sfv "$CURRENT_PATH/$1" $HOME/.$1
}

# Add any dot file
files=('zshrc' 'zpreztorc', 'config/nvim/lua/custom')

echo "Linking..."
for f in $files; do
 link_dot "$f"
done
echo "Done!"

echo "For nvim, Run :MasonInstallAll. Restart nvim."
