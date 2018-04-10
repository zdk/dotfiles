# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

bindkey '^R' history-incremental-search-backward  #ok
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# Some Aliases
alias ssh-blinkenshell='ssh -v -o ServerAliveInterval=60 zdk@ssh.blinkenshell.org -p 2222'
alias i='/sbin/ifconfig'
alias cls='clear;ls'

alias q='QHOME=~/bin/q rlwrap -r ~/bin/q/m32/q'

###########
# Functions
###########

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

encrypt() {
  openssl aes-256-cbc -a -salt -in $1 -out $2
}

decrypt() {
  openssl aes-256-cbc -d -a -in $1 -out $2
}

pg_backup() {
  pg_dump -Z 4 -h $1 -W -U $2 $3
}

pg_restore_z() {
  zcat $4 | psql -h $1 -W -U $2 $3
}

checksum () {
  if [[ $1 = 'md5' ]]; then
      md5 $2
  elif [[ $1 = 'sha1' ]]; then
      shasum -a 1 $2
  elif [[ $1 = 'sha256' ]]; then
      shasum -a 256 $2
  else
      print "Unknown type: $1"
      return 1
  fi
}

whatismyip() {
  curl -s "http://api.duckduckgo.com/?q=ip&format=json" | jq '.Answer'| grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
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

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin

if type rbenv > /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

source /usr/local/share/zsh/site-functions

if [ -f ~/bin/google-cloud-sdk/path.zsh.inc ]; then
  source ~/bin/google-cloud-sdk/path.zsh.inc
fi

if [ -f ~/bin/google-cloud-sdk/completion.zsh.inc ]; then
  source ~/bin/google-cloud-sdk/completion.zsh.inc
fi

# Deer
if [[ -s "$HOME/bin/deer/deer" ]]; then
  source "$HOME/bin/deer/deer"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/bin/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/bin/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HONME/bin/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/bin/google-cloud-sdk/completion.zsh.inc"
fi

# Source local config
if [[ -s "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"

export MYVIMRC=~/.vimrc

