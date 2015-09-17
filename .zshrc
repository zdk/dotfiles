# User configuration
plugins=(git ruby perl tmux)
source $ZSH/oh-my-zsh.sh

bindkey '^R' history-incremental-search-backward  #ok
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word

###########
# Functions
###########

function whatismyip {
  curl -s "http://v4.ipv6-test.com/api/myip.php" && echo
}

source ~/.zshrc.local
