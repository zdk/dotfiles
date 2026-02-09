#!/usr/bin/env zsh

set -euo pipefail

readonly DOTFILES=('zshrc' 'zshrc.local' 'config')

log() { echo -e "[INFO] $1" }
warn() { echo -e "[WARN] $1" }
error() { echo -e "[ERROR] $1" >&2 }

backup_file() {
    [[ -f "$1" && ! -L "$1" ]] && mv "$1" "$1.backup.$(date +%s)"
}

unlink_dot () {
  rm -f "${ZDOTDIR:-$HOME}/.${1}"
}

link_dotfile() {
    local source="$1"
    local target="${ZDOTDIR:-$HOME}/.$1"

    [[ ! -f "$source" ]] && { error "Missing: $source"; return 1; }

    backup_file "$target"
    ln -sf "$source" "$target" && log "Linked $1"
}


main() {
    log "Starting setup..."

    ./install-astronvim.sh

    setopt EXTENDED_GLOB
    for file in $DOTFILES; do
        link_dotfile "$file"
    done

    log "Setup complete!"
}

main "$@"
