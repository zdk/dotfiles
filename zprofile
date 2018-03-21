export ARCHFLAGS="-arch x86_64"
export GOPATH=$HOME/work
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/usr/local/opt/go/libexec/bin:$GOPATH/bin"
export PATH="$PATH:/usr/local/Cellar/rakudo-star/2015.09/bin/"
export LANG='en_US.UTF-8'

export EDITOR='vim'
export VISUAL='vim'

if which rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

[[ -d ~/perl5/lib/perl5 ]] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local



