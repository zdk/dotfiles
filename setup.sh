#!/usr/bin/env zsh
#
# Symlink this repository into $HOME.
#
#   ./setup.sh              install
#   ./setup.sh --dry-run    print what would change, touch nothing
#   ./setup.sh --prune      install, then drop links this script no longer makes
#
# Safe to re-run: links that already point at the right place are left alone.
# Only the software in daily use is linked -- git, gpg, neovim, zsh, wezterm,
# raycast, homebrew, aerospace.
# Everything else the repo carries is listed under "Deliberately NOT linked".

set -euo pipefail

readonly REPO="${0:A:h}"
readonly TARGET_HOME="${ZDOTDIR:-$HOME}"

usage() {
    print -r -- 'usage: setup.sh [-n|--dry-run] [-p|--prune]'
}

DRY_RUN=0
PRUNE=0
for arg in "$@"; do
    case "$arg" in
        -n|--dry-run) DRY_RUN=1 ;;
        -p|--prune)   PRUNE=1 ;;
        -h|--help)    usage; exit 0 ;;
        *)            print -r -- "[ERROR] Unknown option: $arg" >&2
                      usage >&2
                      exit 2 ;;
    esac
done

log()   { print -r -- "[INFO] $1" }
warn()  { print -r -- "[WARN] $1" }
skip()  { print -r -- "[SKIP] $1" }
prune() { print -r -- "[PRUNE] $1" }
error() { print -r -- "[ERROR] $1" >&2 }
did()   { if (( DRY_RUN )); then print -r -- "$1"; else print -r -- "$2"; fi }
run()   { if (( DRY_RUN )); then return 0; else "$@"; fi }

# Files linked as $HOME/.<name>.
readonly HOME_FILES=(
    gitconfig
    gitmessage
    zprofile
    zshrc
)

# Sources whose target path differs. "<source>:<target under $HOME>".
#   gitconfig.work must land on .gitconfig-work -- that is the path
#   gitconfig's [includeIf] directive looks for.
#   The nvim dirs are linked side by side; pick one with NVIM_APPNAME
#   (NVIM_APPNAME=nvim-nvchad nvim), default nvim otherwise.
#   Raycast still has to be pointed at the scripts path once, under
#   Extensions -> Script Commands -> Add Directories. Linking the
#   directory keeps that registration valid as scripts come and go.
readonly LINKS=(
    'gitconfig.work:.gitconfig-work'
    'config/nvim:.config/nvim'
    'config/nvim-minimal:.config/nvim-minimal'
    'config/nvim-nvchad:.config/nvim-nvchad'
    'config/wezterm:.config/wezterm'
    'raycast/scripts:.config/raycast/scripts'
)

# Directories whose *children* are linked into a real directory, so that
# $HOME/.gnupg keeps the keyrings and private keys it already holds.
#   "<source dir>:<target dir under $HOME>"
readonly CHILD_DIRS=(
    'gnupg:.gnupg'
)

# Sources that must not be world-readable or gpg refuses to start.
readonly PRIVATE_FILES=(
    gnupg/dirmngr.conf
    gnupg/gpg-agent.conf
    gnupg/gpg.conf
)

# Directories --prune scans, each one level deep, relative to $HOME. This is
# every directory the script has ever written a link into, so that entries
# dropped from the lists above are still found and cleaned up.
readonly PRUNE_DIRS=(
    .
    .bundle
    .config
    .config/raycast
    .gnupg
    .mutt
    .vim
    bin
)

# Deliberately NOT linked -- still in the repo, just not in daily use:
#   mail stack         muttrc, mailcap, mutt/, msmtprc, offlineimaprc,
#                      offlineimap-helpers.py
#   vim (pre-nvim)     vimrc, vimrc-org, vim/
#   other config/      alacritty, github-copilot, k9s, neofetch, wireshark,
#                      zellij
#   odds and ends      bin/, bundle/, ctags, curlrc, digrc, editorconfig,
#                      eslintrc, gemrc, inputrc, sops.yaml, terraformrc,
#                      tmux.conf, urlview
#   .ssh/ssh_config    placeholder full of <IP>/<username>; would clobber a real config
#   zdotdir/           second, unused zsh framework
#   iterm2.json        imported through iTerm's preferences pane

backup_file() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        run mv "$target" "${target}.backup.$(date +%s)"
        warn "$(did 'Would back up' 'Backed up') existing ${target:t} -> ${target:t}.backup.*"
    fi
    return 0
}

# Absolute targets this run linked or found already correct; --prune keeps them.
typeset -ga LINKED=()

# link <source relative to repo> <target relative to $HOME>
link() {
    local source="$REPO/$1"
    local target="$TARGET_HOME/$2"

    if [[ ! -e "$source" ]]; then
        error "Missing source: $1"
        return 1
    fi

    LINKED+=("${target:a}")

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

# Remove symlinks that point into the repo but are no longer in the lists
# above. Only absolute links into $REPO are touched: a real file, or a link
# pointing anywhere else, is never something this script created.
prune_stale() {
    local dir entry raw rel
    for dir in $PRUNE_DIRS; do
        [[ -d "$TARGET_HOME/$dir" ]] || continue
        for entry in "$TARGET_HOME/$dir"/*(ND@); do
            entry="${entry:a}"
            raw="$(readlink "$entry")"
            [[ "$raw" == "$REPO"/* ]] || continue
            (( ${LINKED[(Ie)$entry]} )) && continue
            # Leave backups alone; they are the user's to inspect and delete.
            [[ "${entry:t}" == *.backup.* ]] && continue
            rel="${entry#$TARGET_HOME/}"
            run rm "$entry"
            prune "$(did 'Would remove' 'Removed') $rel -> ${raw#$REPO/}"
        done
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

    for pair in $LINKS; do
        link "${pair%%:*}" "${pair#*:}"
    done

    # Both the local zshrc and the Brewfile come in a mac and a linux
    # flavour. .Brewfile is the path `brew bundle --global` reads, and
    # aerospace is a mac-only window manager.
    if [[ "$(uname -s)" == "Darwin" ]]; then
        link zshrc.local .zshrc.local
        link Brewfile .Brewfile
        link aerospace.toml .aerospace.toml
    else
        link zshrc.linux.local .zshrc.local
        link Brewfile.linux .Brewfile
    fi

    for pair in $CHILD_DIRS; do
        link_children "${pair%%:*}" "${pair#*:}"
    done

    for file in $PRIVATE_FILES; do
        run chmod 600 "$REPO/$file"
    done

    if (( PRUNE )); then
        print
        prune_stale
    fi

    print
    log "Setup complete."
    (( DRY_RUN )) || warn "Open a new shell to pick up the changes."
    return 0
}

main "$@"
