export ARCHFLAGS="-arch x86_64"
export PATH="$HOME/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin"
export EDITOR='vim'
export LANG='en_US.UTF-8'
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="miloshadzic"

if which rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
