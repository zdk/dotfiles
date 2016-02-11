# User configuration
plugins=(git ruby perl tmux)
source $ZSH/oh-my-zsh.sh

bindkey '^R' history-incremental-search-backward  #ok
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word

if [ -f $(which npm) ]; then
  eval "$(npm completion)"
fi

# Some Aliases
alias ssh-blinkenshell='ssh -v -o ServerAliveInterval=60 zdk@ssh.blinkenshell.org -p 2222'
alias i='/sbin/ifconfig'
alias cls='clear;ls'

###########
# Functions
###########

encrypt() {
  openssl aes-256-cbc -a -salt -in $1 -out $1.enc
}

decrypt() {
  openssl aes-256-cbc -d -a -in $1 -out $1.dec
}

whatismyip() {
  curl -s "http://api.duckduckgo.com/?q=ip&format=json" | jq '.Answer' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
}

ssh-add-host() {
  echo -en "\n\nHost $1\n  HostName $2\n  User $3\n IdentityFile $4" >> ~/.ssh/config
}

ssh-hosts() {
  awk '$1 ~ /^Host$/ {print $2}' ~/.ssh/config
}

bk() {
  cp -a "$1" "${1}_$(date "+%Y-%m-%dT%H:%M:%S%z")"
}

cpucores() {
  sysctl -n hw.ncpu
}

touch_ed() {
  touch $1 && vim $1
}

blog_sync() {
  rsync -rvz -e 'ssh -p 2222' --progress --remove-sent-files _site/. zdk@ssh.blinkenshell.org:/home/zdk/public_html/
}

if type rbenv > /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

source ~/.zshrc.local
source /usr/local/share/zsh/site-functions
