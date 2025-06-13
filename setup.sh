#!/usr/bin/env zsh

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

readonly SCRIPT_DIR="${0:a:h}"
readonly DOTFILES=('zshrc' 'zshrc.local' 'config')

log() { echo -e "${GREEN}[INFO]${NC} $1" }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2 }

backup_file() {
    [[ -f "$1" && ! -L "$1" ]] && mv "$1" "$1.backup.$(date +%s)"
}

unlink_dot () {
  rm -f "${ZDOTDIR:-$HOME}/.${1}"
}

link_dotfile() {
    local source="$SCRIPT_DIR/$1"
    local target="${ZDOTDIR:-$HOME}/.$1"
    
    [[ ! -f "$source" ]] && { error "Missing: $source"; return 1; }
    
    backup_file "$target"
    ln -sf "$source" "$target" && log "Linked $1"
}

install_homebrew() {
    command -v brew >/dev/null && return 0
    
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if uname -s | grep -q 'Linux'; then
        eval "$(/usr/local/bin/brew shellenv)"
        [[ -f "$SCRIPT_DIR/Brewfile" ]] && brew bundle --file="$SCRIPT_DIR/Brewfile.linux" || warn "Brewfile for Linux not found, skipping."
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
        [[ -f "$SCRIPT_DIR/Brewfile" ]] && brew bundle --file="$SCRIPT_DIR/Brewfile" || warn "Brewfile not found, skipping."
    fi
}

install_astronvim() {
    if [[ -x "$SCRIPT_DIR/install-astro.sh" ]]; then
        log "Installing Astro..."
        "$SCRIPT_DIR/install-astronvim.sh"
        command -v nvim >/dev/null && nvim --headless -c 'AstroUpdate' -c 'qa!' 2>/dev/null || true
    else
        warn "Astro installation script not found, skipping."
    fi
}

install(){
    name ="$1"
    if [[ -x "$SCRIPT_DIR/install_$name.sh" ]]; then
        log "Installing $name..."
        "$SCRIPT_DIR/$name"
    else
        warn "Installation script for $name not found, skipping."
    fi
}

main() {
    log "Starting setup..."

    install "homebrew"
    install "astronvim"

    setopt EXTENDED_GLOB
    for file in $DOTFILES; do
        link_dotfile "$file"
    done

    log "Setup complete!"
}

main "$@"
