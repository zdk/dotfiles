#!/usr/bin/env zsh

CURRENT_PATH="$0:a:h"

function link_dot () {
  ln -sfv "$CURRENT_PATH/$1" $HOME/.$1
}

link_dot "vimrc"
