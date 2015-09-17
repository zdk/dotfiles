# User configuration
plugins=(git ruby perl tmux)
source $ZSH/oh-my-zsh.sh

bindkey '^R' history-incremental-search-backward  #ok
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word

###########
# Functions
###########

whatismyip() {
  curl -s "http://v4.ipv6-test.com/api/myip.php" && echo
}

bk() {
	cp -a "$1" "${1}_$(date "+%Y-%m-%dT%H:%M:%S%z")"
}

source ~/.zshrc.local
