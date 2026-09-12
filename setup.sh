#!/usr/bin/env zsh
#
# Symlink this repository into $HOME.
#
#   ./setup.sh              install
#   ./setup.sh --dry-run    print what would change, touch nothing
#   ./setup.sh --prune      install, then drop links this script no longer makes
#
# home/ is a literal image of $HOME: every path under it is linked to the same
# path in $HOME, so the layout of the repo *is* the mapping and nothing in here
# rewrites names. darwin/ and linux/ are overlays of the same shape, of which
# exactly one applies -- that is why both hold a .Brewfile and a .zshrc.local
# rather than carrying a platform suffix.
#
# Everything the repo keeps but does not install lives outside those trees:
# attic/ is kept for reference, imported/ is applied by hand through an app,
# scripts/ is run on demand.
#
# Safe to re-run: links that already point at the right place are left alone.

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

# Trees linked into $HOME, in order. The platform overlay goes last so that it
# wins if it ever names the same path as home/.
TREES=(home)
case "$(uname -s)" in
    Darwin) TREES+=(darwin) ;;
    *)      TREES+=(linux) ;;
esac
readonly TREES

# Directories that must stay REAL directories in $HOME, linked child by child,
# because things that are not ours live in them too: .config holds other
# programs' state, .config/raycast the app's own extensions and cache, .gnupg
# the keyrings and private keys, bin any script not from this repo.
#
# A directory NOT listed here is linked whole, which is what makes a program
# writing into its own config dir (nvim into .config/nvim) write to the repo.
readonly REAL_DIRS=(
    .config
    .config/raycast
    .gnupg
    bin
)

# Directories --prune scans, each one level deep, relative to $HOME. The ones
# marked historical hold no link today; they are still scanned so that links
# left by older versions of this script are found and cleaned up.
readonly PRUNE_DIRS=(
    .
    .bundle          # historical
    .config
    .config/raycast
    .gnupg
    .mutt            # historical
    .vim             # historical
    bin
)

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

    # A broken link into the repo is one of ours from an earlier layout, so
    # replace it instead of backing up something that points nowhere.
    if [[ -L "$target" && ! -e "$target" && "$(readlink "$target")" == "$REPO"/* ]]; then
        run rm "$target"
    fi

    backup_file "$target"
    [[ -d "${target:h}" ]] || run mkdir -p "${target:h}"
    # -n keeps a directory symlink from being replaced *inside* itself.
    run ln -sfn "$source" "$target"
    log "$(did 'Would link' 'Linked') $2"
    return 0
}

# Walk one tree, linking each entry at the same path under $HOME. Recurses only
# into REAL_DIRS; everything else is linked as it stands.
# link_tree <tree> [<path relative to the tree>]
link_tree() {
    local tree="$1" rel="${2:-}"
    local abs="$REPO/$tree${rel:+/$rel}" entry name child

    for entry in "$abs"/*(ND); do
        name="${entry:t}"
        [[ "$name" == .DS_Store ]] && continue
        child="${rel:+$rel/}$name"

        if [[ -d "$entry" ]] && (( ${REAL_DIRS[(Ie)$child]} )); then
            [[ -d "$TARGET_HOME/$child" ]] || run mkdir -p "$TARGET_HOME/$child"
            link_tree "$tree" "$child"
        else
            link "$tree/$child" "$child"
        fi
    done
    return 0
}

# Remove symlinks that point into the repo but are no longer part of a tree.
# Only absolute links into $REPO are touched: a real file, or a link pointing
# anywhere else, is never something this script created.
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
    log "Trees:  $TREES"
    print

    local tree file
    for tree in $TREES; do
        link_tree "$tree"
    done

    # gpg refuses to start if these are group- or world-readable.
    for file in "$REPO"/home/.gnupg/*(ND.); do
        run chmod 600 "$file"
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
