#!/usr/bin/env zsh
#
# Tests for setup.sh. Every case runs against a throwaway $HOME, which works
# because setup.sh takes its target from $ZDOTDIR when that is set.
#
#   ./tests/setup_test.zsh
#
# Platform matters: the darwin/ overlay applies on macOS and linux/ on
# everything else, so the expected link set differs per host.

set -uo pipefail

zmodload -F zsh/stat b:zstat

readonly REPO="${0:A:h:h}"
readonly SETUP="$REPO/setup.sh"

# Globs do not expand inside [[ ]], so count matches through an array.
# backups <home> <name> -> number of <name>.backup.* entries
backups() {
    local -a found=("$1/$2".backup.*(N))
    print -r -- ${#found}
}

typeset -g PASS=0 FAIL=0

ok()   { print -r -- "  ok   $1"; (( PASS++ )) }
bad()  { print -r -- "  FAIL $1"; (( FAIL++ )) }
case_() { print -r -- "» $1" }

# A fresh empty home for one case. Never the real one.
new_home() {
    local dir
    dir="$(mktemp -d)" || exit 1
    print -r -- "$dir"
}

setup() { ZDOTDIR="$1" "$SETUP" "${@:2}" }

# assert_link <home> <path> <expected source relative to repo>
assert_link() {
    local home="$1" path="$2" want="$3" target="$1/$2"
    if [[ ! -L "$target" ]]; then
        bad "$path is not a symlink"
    elif [[ ! -e "$target" ]]; then
        bad "$path is a broken link"
    elif [[ "${target:A}" != "${REPO:A}/$want" ]]; then
        bad "$path -> ${target:A}, wanted $want"
    else
        ok "$path -> $want"
    fi
}

assert_absent() {
    [[ -e "$1/$2" || -L "$1/$2" ]] && bad "$2 should not exist" || ok "$2 absent"
}

assert_present() {
    [[ -e "$1/$2" ]] && ok "$2 still there" || bad "$2 was lost"
}

# Links every platform gets, as <path>:<source>.
typeset -a COMMON=(
    '.gitconfig:home/.gitconfig'
    '.gitconfig-work:home/.gitconfig-work'
    '.gitmessage:home/.gitmessage'
    '.zshrc:home/.zshrc'
    '.zprofile:home/.zprofile'
    '.config/nvim:home/.config/nvim'
    '.gnupg/gpg.conf:home/.gnupg/gpg.conf'
    'bin/pb:home/bin/pb'
)
if [[ "$(uname -s)" == Darwin ]]; then
    typeset -a PLATFORM=(
        '.Brewfile:darwin/.Brewfile'
        '.zshrc.local:darwin/.zshrc.local'
        '.aerospace.toml:darwin/.aerospace.toml'
        '.config/raycast/scripts:darwin/.config/raycast/scripts'
    )
else
    typeset -a PLATFORM=(
        '.Brewfile:linux/.Brewfile'
        '.zshrc.local:linux/.zshrc.local'
    )
fi

# --- the script itself parses -------------------------------------------------
case_ 'setup.sh parses'
if zsh -n "$SETUP"; then ok 'zsh -n'; else bad 'zsh -n'; fi

# --- a dry run writes nothing at all -----------------------------------------
case_ 'dry run touches nothing'
H="$(new_home)"
setup "$H" --dry-run >/dev/null
if [[ -z "$(ls -A "$H")" ]]; then ok 'home still empty'; else bad "home gained: $(ls -A "$H")"; fi
rm -rf "$H"

# --- install ------------------------------------------------------------------
case_ 'install creates the expected links'
H="$(new_home)"
setup "$H" >/dev/null
for pair in $COMMON $PLATFORM; do
    assert_link "$H" "${pair%%:*}" "${pair#*:}"
done
# Whole directories are linked, single files inside real dirs are not.
[[ -L "$H/.config/nvim" ]] && ok '.config/nvim is one link (program writes reach the repo)' \
                           || bad '.config/nvim should be a single symlink'
[[ -L "$H/.config" ]] && bad '.config must stay a real directory' \
                      || ok '.config is a real directory'
[[ -L "$H/.gnupg" ]] && bad '.gnupg must stay a real directory' \
                     || ok '.gnupg is a real directory'
[[ -L "$H/bin" ]] && bad 'bin must stay a real directory' || ok 'bin is a real directory'

case_ 'no dangling links anywhere in the test home'
dangling=$(find "$H" -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l | tr -d ' ')
(( dangling == 0 )) && ok 'every link resolves' || bad "$dangling dangling links"

case_ 'the wrong platform overlay is not applied'
if [[ "$(uname -s)" == Darwin ]]; then
    assert_link "$H" '.Brewfile' 'darwin/.Brewfile'
else
    assert_absent "$H" '.aerospace.toml'
fi

# --- re-running changes nothing ----------------------------------------------
case_ 'second run is idempotent'
out="$(setup "$H" --prune)"
if print -r -- "$out" | grep -qE 'Linked|Backed up|Removed'; then
    bad "second run acted: $(print -r -- "$out" | grep -E 'Linked|Backed up|Removed' | head -3)"
else
    ok 'nothing linked, backed up or removed'
fi
rm -rf "$H"

# --- content that is not ours survives ---------------------------------------
case_ 'real directories keep foreign content'
H="$(new_home)"
mkdir -p "$H/bin" "$H/.config/raycast/extensions"
print -r -- 'mine' > "$H/bin/my-own-script"
print -r -- 'mine' > "$H/.config/raycast/extensions/keep-me"
setup "$H" >/dev/null
assert_present "$H" 'bin/my-own-script'
assert_present "$H" '.config/raycast/extensions/keep-me'
rm -rf "$H"

# --- backups ------------------------------------------------------------------
case_ 'a real file and a foreign link are backed up'
H="$(new_home)"
print -r -- 'real' > "$H/.zshrc"
ln -s /etc/hosts "$H/.gitmessage"
setup "$H" >/dev/null
assert_link "$H" '.zshrc' 'home/.zshrc'
assert_link "$H" '.gitmessage' 'home/.gitmessage'
(( $(backups "$H" .zshrc) == 1 )) && ok '.zshrc was backed up' || bad '.zshrc backup missing'
(( $(backups "$H" .gitmessage) == 1 )) && ok '.gitmessage was backed up' || bad '.gitmessage backup missing'
rm -rf "$H"

case_ 'a broken link into the repo is replaced, not backed up'
H="$(new_home)"
ln -s "$REPO/gitconfig" "$H/.gitconfig"      # the pre-reorg path: now dangling
setup "$H" >/dev/null
assert_link "$H" '.gitconfig' 'home/.gitconfig'
(( $(backups "$H" .gitconfig) == 0 )) && ok 'no backup left behind' \
                                      || bad 'pointless backup of a dead link'
rm -rf "$H"

# --- prune --------------------------------------------------------------------
case_ 'prune removes stale repo links only'
H="$(new_home)"
setup "$H" >/dev/null
ln -s "$REPO/attic/misc/tmux.conf" "$H/.tmux.conf"   # ours, no longer linked
ln -s /etc/hosts "$H/.foreign"                       # not ours
print -r -- 'real' > "$H/.realfile"
ln -s "$REPO/attic/misc/ctags" "$H/.ctags.backup.123"
setup "$H" --prune >/dev/null
assert_absent  "$H" '.tmux.conf'
assert_present "$H" '.foreign'
assert_present "$H" '.realfile'
assert_present "$H" '.ctags.backup.123'
assert_link    "$H" '.zshrc' 'home/.zshrc'
rm -rf "$H"

case_ 'prune finds links left in directories no longer used'
H="$(new_home)"
mkdir -p "$H/.mutt"
ln -s "$REPO/attic/mail/mailcap" "$H/.mutt/mailcap"
setup "$H" --prune >/dev/null
assert_absent "$H" '.mutt/mailcap'
rm -rf "$H"

# --- flags --------------------------------------------------------------------
case_ 'an unknown flag is refused'
H="$(new_home)"
setup "$H" --bogus >/dev/null 2>&1
(( $? == 2 )) && ok 'exit 2' || bad "expected exit 2, got $?"
rm -rf "$H"

# --- gpg permissions ----------------------------------------------------------
case_ 'gnupg configs are not group or world readable'
H="$(new_home)"
setup "$H" >/dev/null
for f in "$REPO"/home/.gnupg/*(N.); do
    # 8#777, not 0777: zsh reads a leading zero as decimal unless
    # OCTAL_ZEROES is set, which would mask with 777 decimal.
    mode=$(printf '%o' $(( $(zstat +mode -- "$f") & 8#777 )))
    if [[ "$mode" == 600 ]]; then
        ok "${f:t} is 600"
    else
        bad "${f:t} is $mode"
    fi
done
rm -rf "$H"

print
print -r -- "passed $PASS, failed $FAIL"
(( FAIL == 0 ))
