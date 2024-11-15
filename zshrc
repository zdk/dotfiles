# ZPrezto init
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Bindkey
bindkey '^R' history-incremental-search-backward  #ok
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# Editor: VIM
export EDITOR='nvim'
export VISUAL='nvim'

# RC File: VIM
export MYVIMRC=~/.vimrc


# Aliases: k8s
alias k=kubectl

# Aliases: misc
alias tf='terraform'
alias ping='prettyping --nolegend'
alias i='/sbin/ifconfig'
alias cls='clear;ls'
alias ll='ls -la'
alias สส='ll'
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
alias help='tldr'
alias mutt='LC_ALL=en_us.UTF-8 neomutt'
alias nasm='/usr/local/bin/nasm'
alias vim-noplug='vim -u NONE -U NONE --noplugin -N'
alias vim='nvim'
alias vi='vim'
alias vpn-connect='lazy-connect'
alias zel='zellij'
alias p='pulumi'
alias sed="gsed"
alias gi='git'

# k8s
# Completition
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# k3s
kubeconfig-k3s() {
  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
}

# Brew shellenv
if [[ -e "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Path: Go
export GOPATH=$HOME/go
export PATH=$HOME/bin:$HOME/go/bin:/usr/local/go/bin:$PATH


# Path: Rust
export PATH=$HOME/.cargo/bin:$PATH

# Path: Ruby

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# For compilers
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

# Path: Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Dotnet
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# rbenv
if type rbenv > /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# Path: Brew package manager
[ -f /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


###########
# Functions
###########


encrypt() {
  openssl aes-256-cbc -a -salt -in $1 -out $2
}

decrypt() {
  openssl aes-256-cbc -d -a -in $1 -out $2
}

pg-backup() {
  pg_dump -Z 4 -h $1 -W -U $2 $3
}

pg-restore_z() {
  zcat $4 | psql -h $1 -W -U $2 $3
}

debug-http-request() {
  socat - TCP-LISTEN:$1,fork
}

debug-sni-request() {
  curl -k -I --resolve $1:80:$2 https://$1/
}

killport() {
  while test $# -gt 0
  do
      port_number=$1
      pid=$(lsof -P | grep ':'$port_number'[[:space:]](LISTEN)' | awk '{print $2}')
      if ! kill -QUIT $pid > /dev/null 2>&1; then
        echo -e "\e[0;31mNo process running\e[0m $port_number port" >&2
      else
        echo -e "Kill $port_number \e[0;32msuccessfully\e[0m"
      fi
      shift
  done
}

lsport() {
   sudo lsof -nP -i4TCP | grep '(LISTEN)' | awk 'BEGIN{print "Name PID Host:Port"};{print $1 " " $2 " " $9}'
}

delete-git-branch() {
  git branch -D $1
  git push origin --delete $1
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

add-ssh-host() {
  echo -en "\n\nHost $1\n  HostName $2\n  User $3\n IdentityFile $4" >> ~/.ssh/config
}

show-ssh-hosts() {
  awk '$1 ~ /^Host$/ {print $2}' ~/.ssh/config
}

bak-now() {
  cp -a "$1" "${1}_$(date "+%Y-%m-%dT%H:%M:%S%z")"
}

cpu-cores() {
  sysctl -n hw.ncpu
}

cpu-generation(){
  sysctl -n machdep.cpu.brand_string
}

touch-ed() {
  touch $1 && vim $1
}

sync-files() {
  rsync -rvz -e 'ssh -p 2222' --progress --remove-sent-files _site/. zdk@ssh.blinkenshell.org:/home/zdk/public_html/
}

view-ssl-remote-cert() {
  openssl s_client -showcerts -connect $1:443
}

join-by() {
  local IFS="$1"; shift; echo "$*";
}

cdls() {
  cd $1 && ls -la $1
}

cdmk() {
  if [[ "$#" -ne 1 ]]; then
      echo "Usage: $0 <directory>"
      exit 1
  fi
  TARGET_DIR=$1
  if [[ -d "$TARGET_DIR" ]]; then
    cd $TARGET_DIR || { return 1; }
  else
      read "CONFIRM?Do you want to create a new directory in '$TARGET_DIR'? (yes/no): "
      if [[ "$CONFIRM" == "yes" ]]; then
          mkdir -p "$TARGET_DIR"
          if [[ $? -eq 0 ]]; then
              echo "'$TARGET_DIR' created."
              cd "$TARGET_DIR" || { echo "Failed to change directory to '$TARGET_DIR'"; return 1; }
          else
              echo "Failed to create directory '$TARGET_DIR'"
              return 1
          fi
      else
          echo "Directory creation aborted."
      fi
  fi
}

nodes-ip-k8s() {
  EXTERNAL_IP=$(kubectl get node $1 -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}');
  INTERNAL_IP=$(kubectl get node $1 -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}');
  echo "External IP:" $EXTERNAL_IP;
  echo "Internal IP:" $INTERNAL_IP;
}

aws-switch-profile() {
  aws-profiles | grep "$1"
  if [[ $? -ne 0 ]]; then
    echo "profile: $1 not configured in '$HOME/.aws/config'.\n"
    echo "current configured profiles:"
    aws-profiles
    return 1
  else
    export AWS_DEFAULT_PROFILE="$1" AWS_PROFILE="$1"
  fi
}

aws-profiles() {
  profiles=$(aws --no-cli-pager configure list-profiles 2> /dev/null)
  if [[ -z "$profiles" ]]; then
    echo "No AWS profiles found in '$HOME/.aws/config"
    return 1
  else
    echo $profiles
  fi
}

scan-port() {
  TARGET_IP=$1
  nmap -sC -sV -Pn -n -p- $TARGET_IP --open
}

k-api() {
 kubectl config view --minify --output jsonpath="{.clusters[*].cluster.server}"
}

# Source files
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.works ] && source "$HOME/.zshrc.works"
[ -f ~/.zshrc.local ] && source "$HOME/.zshrc.local"

[ -f /opt/homebrew/bin/fzf ] && source <(fzf --zsh)

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Path: Python
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="/Users/zdk/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/opt/nvim-linux64/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

source <(kubectl completion zsh)

source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
. "$HOME/.deno/env"
