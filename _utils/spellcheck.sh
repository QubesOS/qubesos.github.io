#!/bin/bash

set -e
set -o pipefail

v() {
    if [ -n "$VERBOSE" ]; then
        echo "$@"
    fi
}
vtime() {
    if [ -n "$VERBOSE" ]; then
        time "$@"
    else
        "$@"
    fi
}

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

check_site() {
    local site_in=$1
    local words_out=$2

    rm -rf "$words_out"
    mkdir -p "$words_out/suspects.tree"
    v "Checking $site_in, storing results in $words_out"
    find "$site_in" -mindepth 1 -type d -printf '%P\0' \
      | ( cd "$words_out/suspects.tree" && xargs -0 mkdir -p ) >&2
    find "$site_in" -type f -name '*.html' -printf '%P\0' \
      | while read -d '' f; do
        extract_words "$site_in/$f" | check_words | sort -u \
          > "$words_out/suspects.tree/${f}.wrong"
    done
    find "$words_out/suspects.tree" -type f -exec cat {} + | sort -u \
      > "$words_out/suspects.flat"
}

diff_checked() {
    local old=$1
    local new=$2
    local diff_dir=$3

    rm -rf "$diff_dir"
    mkdir -p "$diff_dir"
    diff -u {"$old","$new"}/suspects.flat > "$diff_dir/diff" || :
    grep -v '^\( \|@\|+++\|---\)' < "$diff_dir/diff" | LC_ALL=C sort \
      > "$diff_dir/plusminus" || :
    grep '^+' < "$diff_dir/plusminus" > "$diff_dir/plus" || :
    grep '^-' < "$diff_dir/plusminus" > "$diff_dir/minus" || :
}


ansi() { cc=$1; shift; printf "\x1b[${cc}m%s\x1b[0m\n" "$*" ; }
red() { ansi 31 "$@" ; }
green() { ansi 32 "$@" ; }

show_in_src() {
    local src_dir=$1

    while read -d $'\n' suspect; do
        ( cd "$src_dir" && \
          find -type f -not -path './_site/*' -not -path './.git/*' \
            -exec grep --color=always -rHnwF "$suspect" {} + )
    done
}

report_diff() {
    local diff_dir=$1
    local src_dir=$2

    if [ -s "$diff_dir/plus" ]; then
        red 'The following new unknown spellings were introduced:'
        sed 's/^/    /' < "$diff_dir/plus"
    else
        green 'No new unique misspellings were introduced.'
    fi

    if [ -s "$diff_dir/minus" ]; then
        echo
        echo 'In addition, the following suspicious spellings were eliminated:'
        sed 's/^/    /' < "$diff_dir/minus"
    fi

    if [ -s "$diff_dir/plus" ]; then
        echo
        echo 'The introduced suspects in context are:'
        echo
        sed 's/^+//' < "$diff_dir/plus" | show_in_src "$src_dir"
        echo
        echo 'If these are false-positives, simply commit as is and they will'
        echo 'be ignored in the future.'
    fi
}

usage() {
    echo "Usage: ${0##*/} [[old-built-site] HEAD-built-site]" >&2
    exit 2
}

# Allow specifying someplace to save the intermediate state,
# otherwise put it in a temp dir and remove it on exit
if [ -n "$SPELLCHECK_WORKDIR" ]; then
    d="$SPELLCHECK_WORKDIR"
    rm -rf "$d"
    mkdir -p "$d"
else
    d=$(mktemp -d)
    trap 'rm -rf "$d"' EXIT
fi
v "Using $d as work dir"

if command -v hunspell > /dev/null; then
    # convert en_US dictionary to UTF-8
    dict_dir="$d/dict"
    mkdir -p "$dict_dir"
    dict=$(hunspell -D 2>&1 | grep '/en_US$')
    cp -r "$dict".* "$dict_dir/"
    sed -i 's/^SET ISO8859-1/SET UTF-8/' $dict_dir/en_US.aff
    check_words() { hunspell -l -d "$dict_dir/en_US"; }
elif command -v aspell > /dev/null; then
    check_words() { aspell | grep '^[#&]' | cut -d' ' -f2; }
else
    echo "${0##*/}: No spell checker installed. Need hunspell or aspell." >&2
    exit 1
fi


repo="$(dirname "$(dirname "$(readlink -f "$0")")")"

case $# in
0)
    if ! [ -d "$repo/_site" ]; then
        echo "${0##*/}: zero-argument form requires a built site in _site" >&2
        usage
    fi
    vtime check_site "$repo/_site" "$d/work"
    v
    show_in_src "$repo" < "$d/suspects.flat"
    ;;
1)
    vtime check_site "$1" "$d/work"
    v
    show_in_src "$repo" < "$d/work/suspects.flat"
    ;;
2)
    vtime check_site "$1" "$d/old"
    vtime check_site "$2" "$d/new"
    v
    diff_checked "$d/old" "$d/new" "$d/diff"
    report_diff "$d/diff"
    # exit 0 if no new unknown unique spellings were introduced, 1 otherwise
    ! test -s "$d/diff/plus"
    ;;
*)
    usage
    ;;
esac
