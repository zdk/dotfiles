# Login-shell environment.
# Interactive settings (aliases, functions, completions) live in ~/.zshrc
# and ~/.zshrc.local. Keep the two in sync where they overlap.

export LANG='en_US.UTF-8'

export EDITOR='nvim'
export VISUAL='nvim'

# Go. Must match ~/.zshrc.local, which also exports GOPATH.
export GOPATH="$HOME/go"

# Prepend rather than replace: on macOS /etc/zprofile has already run
# path_helper to build a correct base PATH.
export PATH="$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH"

# GPG Suite, when installed.
[[ -d /usr/local/MacGPG2/bin ]] && export PATH="/usr/local/MacGPG2/bin:$PATH"

[[ -d ~/perl5/lib/perl5 ]] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

# rbenv is initialised in ~/.zshrc.local; do not duplicate it here.

true

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
