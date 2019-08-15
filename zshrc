if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

bindkey '^R' history-incremental-search-backward  #ok
bindkey '^[b' backward-word
bindkey '^[f' forward-word

export EDITOR='vim'
export VISUAL='vim'

# Some Aliases
alias ssh-blinkenshell='ssh -v -o ServerAliveInterval=60 zdk@ssh.blinkenshell.org -p 2222'
alias i='/sbin/ifconfig'
alias cls='clear;ls'
alias สส='ll'
alias ping='prettyping --nolegend'
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
alias help='tldr'
alias q='QHOME=~/bin/q rlwrap -r ~/bin/q/m32/q'
alias mutt='LC_ALL=en_us.UTF-8 neomutt'
alias nasm='/usr/local/bin/nasm'
alias vim-noplug='vim -u NONE -U NONE --noplugin -N'
alias tf='terraform'

# Kubernetes
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin:/usr/local/go/bin:/usr/local/opt/go/libexec/bin

# Ruby
if type rbenv > /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# Python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# VIM
export MYVIMRC=~/.vimrc

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

debug_http_request() {
  socat - TCP-LISTEN:$1,fork
}

make_sni_request() {
  curl -k -I --resolve $1:80:$2 https://$1/
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

gen-cert() {
  openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out MyCertificate.crt -keyout MyKey.key
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

ssl_view_remote_cert() {
  openssl s_client -showcerts -connect $1:443
}

join_by() {
  local IFS="$1"; shift; echo "$*";
}

# Source local config
if [[ -s "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
