#!/bin/bash

set -e
set -o pipefail

v() {
    if [ -n "$VERBOSE" ]; then
        echo "$@"
    fi
}

if command -v hunspell > /dev/null; then
    check_words() { hunspell -l; }
elif command -v aspell > /dev/null; then
    check_words() { aspell | grep '^[#&]' | cut -d' ' -f2; }
else
    echo "${0##*/}: No spell checker installed. Need hunspell or aspell." >&2
    exit 1
fi

extract_words() {
    pandoc -tjson "$@" | jq -r '
    # will be builtin in a future version of jq. is already in master
    # Apply f to composite entities recursively, and to atoms
    def walk(f):
      . as $in
      | if type == "object" then
          reduce keys[] as $key
            ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
      elif type == "array" then map( walk(f) ) | f
      else f
      end;

    # strip code
    walk (
      if (type == "object") then
        if (.t == "CodeBlock" or .t == "Code") then
          empty
        else
          .
        end
      else
        .
      end
    ) |

    # extract raw string nodes
    .. | select(type=="object" and has("t") and .t=="Str") | .c
    '
}

find_suspects() {
    local workdir=$1
    local outdir=$2
    mkdir -p "$outdir"
    v "Parsing $outdir..."
    find "$workdir" -mindepth 1 -type d -printf '%P\0' \
      | ( cd "$outdir" && xargs -0 mkdir -p ) >&2
    find "$workdir" -type f -name '*.html' -printf '%P\0' \
      | while read -d '' f; do
        extract_words "${workdir}/${f}" | check_words | sort -u \
          > "${outdir}/${f}.wrong"
    done
}

check_one() {
    local ref=$1
    local checkout="${d}/${ref}.checkout"
    [ -d "$checkout" ] && { v "Using cached $ref"; return; }
    local tree="${d}/${ref}.suspects.tree"
    local flat="${d}/${ref}.suspects.flat"

    # We want to make a duplicate of the repo without requiring re-cloning it
    # over the network. Perhaps the commits we want to test are not pushed to
    # the remote. This is particularly a problem with submodules, which (when
    # cloned) reset their url to the upstream remote rather than the
    # superproject origin. There are several options:
    # - hackily fix up the submodule urls post-clone
    # - potentially use git-worktree(1), but the BUGS section of the man page
    #   (at least in 2.7.4) says:
    #      Multiple checkout in general is still experimental, and the support
    #      for submodules is incomplete. It is NOT recommended to make multiple
    #      checkouts of a superproject.
    # - copy the whole .git dir, which is very much overkill especially when
    #   used on a local repo (as opposed to CI) which may carry more objects,
    #   but seems to be the least fragile way I've found so far.

    v "Checking out $ref..."
    mkdir -p "$checkout"
    cp -pr .git "$checkout"
    git -C "$checkout" checkout --force "$ref"
    git -C "$checkout" submodule update --checkout --recursive --force

    v "Building $ref..."
    ( cd "$checkout" && make > /dev/null )
    find_suspects "$checkout/_site" "$tree"
    find "$tree" -type f -exec cat {} + | sort -u > "$flat"
}

diff_two() {
    local old=$1
    local new=$2
    local cmp="${d}/${old}..${new}"
    check_one "$old"
    check_one "$new"
    [ -e "${cmp}.plusminus" ] && { v "Using cached diff"; return; }
    diff -u "$d"/{"${old}","${new}"}.suspects.flat > "${cmp}.diff.flat" || :
    grep -v '^\( \|@\|+++\|---\)' < "${cmp}.diff.flat" | LC_ALL=C sort \
      > "${cmp}.plusminus" || :
    grep '^+' < "${cmp}.plusminus" > "${cmp}.plus" || :
    grep '^-' < "${cmp}.plusminus" > "${cmp}.minus" || :
}


ansi() { cc=$1; shift; printf "\x1b[${cc}m%s\x1b[0m\n" "$*" ; }
red() { ansi 31 "$@" ; }
green() { ansi 32 "$@" ; }

show() {
    local ref=$1
    while read -d $'\n' suspect; do
        ( cd "$d/${ref}.checkout" && \
          find -type f -exec grep --color=always -rHnwF "$suspect" {} + )
    done
}

diff_report() {
    local old=$1
    local new=$2
    local plus=${d}/${old}..${new}.plus
    local minus=${d}/${old}..${new}.minus

    diff_two "$old" "$new"

    echo "Spelling report for ${old:0:8}..${new:0:8}:"
    echo
    if [ -s "$plus" ]; then
        red 'The following new unknown spellings were introduced:'
        sed 's/^/    /' < "$plus"
    else
        green 'No new unique misspellings were introduced.'
    fi

    if [ -s "$minus" ]; then
        echo
        echo 'In addition, the following suspicious spellings were eliminated:'
        sed 's/^/    /' < "$minus"
    fi

    if [ -s "$plus" ]; then
        echo
        echo 'The introduced suspects in context are:'
        echo
        sed 's/^+//' < "$plus" | show "$new"
        echo
        echo 'If these are false-positives, simply commit as is and they will'
        echo 'be ignored in the future.'
    fi
}


if [ -n "$SPELL_CHECK_CACHE" ]; then
    d=$SPELL_CHECK_CACHE
    mkdir -p "$d"
    echo "Using spell check cache dir: $d"
else
    d=$(mktemp -d)
    trap 'rm -rf "$d"' EXIT
fi

case $# in
0)
    old=$(git rev-parse HEAD)
    new=$(git rev-parse refs/remotes/origin/master)
    ;;
1)
    old=$(git rev-parse "$1"^)
    new=$(git rev-parse "$1")
    ;;
2)
    old=$(git rev-parse "$1")
    new=$(git rev-parse "$2")
    ;;
*)
    echo "Usage: ${0##*/} [[old-ref] new-ref]" >&2
    exit 2
esac

diff_report "$old" "$new"

# exit 0 if no new unknown unique spellings were introduced, 1 otherwise
! test -s "$plus"
