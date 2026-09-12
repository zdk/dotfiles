#!/usr/bin/env zsh
#
# Symlink this repository into $HOME.
#
#   ./setup.sh              install
#   ./setup.sh --dry-run    print what would change, touch nothing
#
# Safe to re-run: links that already point at the right place are left alone.

set -euo pipefail

readonly REPO="${0:A:h}"
readonly TARGET_HOME="${ZDOTDIR:-$HOME}"

DRY_RUN=0
if [[ "${1:-}" == (-n|--dry-run) ]]; then
    DRY_RUN=1
fi

log()   { print -r -- "[INFO] $1" }
warn()  { print -r -- "[WARN] $1" }
skip()  { print -r -- "[SKIP] $1" }
error() { print -r -- "[ERROR] $1" >&2 }
# Verb that matches what actually happened, so a dry run cannot claim otherwise.
did()   { if (( DRY_RUN )); then print -r -- "$1"; else print -r -- "$2"; fi }
run()   { if (( DRY_RUN )); then return 0; else "$@"; fi }

# Files linked as $HOME/.<name>.
readonly HOME_FILES=(
    aerospace.toml
    ctags
    curlrc
    digrc
    editorconfig
    eslintrc
    gemrc
    gitconfig
    gitmessage
    inputrc
    msmtprc
    muttrc
    offlineimaprc
    sops.yaml
    terraformrc
    tmux.conf
    urlview
    vimrc
    zprofile
    zshrc
)

# Sources whose target name differs. "<source>:<target under $HOME>".
#   gitconfig.work must land on .gitconfig-work -- that is the path
#   gitconfig's [includeIf] directive looks for.
readonly RENAMED=(
    'gitconfig.work:.gitconfig-work'
    'mailcap:.mutt/mailcap'
    'offlineimap-helpers.py:bin/offlineimap-helpers.py'
)

# Directories whose *children* are linked into a real directory, so that
# $HOME/.config and friends keep anything they already hold.
#   "<source dir>:<target dir under $HOME>"
readonly CHILD_DIRS=(
    'bin:bin'
    'bundle:.bundle'
    'config:.config'
    'gnupg:.gnupg'
    'mutt:.mutt'
    'vim:.vim'
)

# Sources that must not be world-readable or their program refuses to start.
readonly PRIVATE_FILES=(msmtprc offlineimaprc gnupg/gpg-agent.conf)

# Sources that need the executable bit before they are useful on $PATH.
readonly EXECUTABLES=(bin/clear-contexts bin/dotfiles bin/pb)

# Deliberately NOT linked:
#   .ssh/ssh_config    placeholder full of <IP>/<username>; would clobber a real config
#   zdotdir/           second, unused zsh framework
#   raycast/           imported through the Raycast app, not $HOME
#   iterm2.json        imported through iTerm's preferences pane
#   vimrc-org          alternate vimrc, kept for reference
#   Brewfile*          consumed by `brew bundle`, not a dotfile

backup_file() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        run mv "$target" "${target}.backup.$(date +%s)"
        warn "$(did 'Would back up' 'Backed up') existing ${target:t} -> ${target:t}.backup.*"
    fi
    return 0
}

# link <source relative to repo> <target relative to $HOME>
link() {
    local source="$REPO/$1"
    local target="$TARGET_HOME/$2"

    if [[ ! -e "$source" ]]; then
        error "Missing source: $1"
        return 1
    fi

    # Already correct? Leave it.
    if [[ -L "$target" && "${target:A}" == "${source:A}" ]]; then
        skip "$2"
        return 0
    fi

    backup_file "$target"
    [[ -d "${target:h}" ]] || run mkdir -p "${target:h}"
    # -n keeps a directory symlink from being replaced *inside* itself.
    run ln -sfn "$source" "$target"
    log "$(did 'Would link' 'Linked') $2"
    return 0
}

link_children() {
    local src_dir="$REPO/$1" target_dir="$2" child
    if [[ ! -d "$src_dir" ]]; then
        error "Missing source directory: $1"
        return 1
    fi
    [[ -d "$TARGET_HOME/$target_dir" ]] || run mkdir -p "$TARGET_HOME/$target_dir"
    for child in "$src_dir"/*(N); do
        link "$1/${child:t}" "$target_dir/${child:t}"
    done
    return 0
}

main() {
    (( DRY_RUN )) && log "Dry run -- nothing will be changed."
    log "Repo:   $REPO"
    log "Target: $TARGET_HOME"
    print

    local file pair source target
    for file in $HOME_FILES; do
        link "$file" ".$file"
    done

    for pair in $RENAMED; do
        link "${pair%%:*}" "${pair#*:}"
    done

    # Platform-specific local zshrc; both land on ~/.zshrc.local.
    if [[ "$(uname -s)" == "Darwin" ]]; then
        link zshrc.local .zshrc.local
    else
        link zshrc.linux.local .zshrc.local
    fi

    for pair in $CHILD_DIRS; do
        link_children "${pair%%:*}" "${pair#*:}"
    done

    for file in $PRIVATE_FILES; do
        run chmod 600 "$REPO/$file"
    done

    for file in $EXECUTABLES; do
        run chmod +x "$REPO/$file"
    done

    print
    log "Setup complete."
    (( DRY_RUN )) || warn "Open a new shell to pick up the changes."
    return 0
}

main "$@"
