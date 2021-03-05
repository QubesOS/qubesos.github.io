#!/bin/bash

set -x
set -e
set -o pipefail

echo -e "section_start:$(date +%s):prepare[collapsed=true]\r\e[0KSetup"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH=$HOME/bin:$PATH

is_pr() {
    # 1: Gitlab as primary instance of QubesOS
    # 2: Github to GitlabCI (@fepitre's tools)
    if [ -n "$CI_MERGE_REQUEST_ID" ] && [ $CI_MERGE_REQUEST_ID > 0 ]; then
        return 0
    elif [ -n "$CI_COMMIT_BRANCH" ] && [ "${CI_COMMIT_BRANCH:0:2}" == pr ]; then
        return 0
    else
        return 1
    fi
}

cd "$(dirname "$0")/.."

# from https://github.com/gjtorikian/html-proofer
#     When installation speed matters, set NOKOGIRI_USE_SYSTEM_LIBRARIES to
#     true in your environment. This is useful for increasing the speed of
#     your Continuous Integration builds.
export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
gem install github-pages json
# force old version to avoid gjtorikian/html-proofer#602
gem install html-proofer --version 3.16.0

repo_owner=${CI_PROJECT_PATH%%/*}
repo_name=${CI_PROJECT_PATH#*/}

# Use modules of same owner so you can test whole site before proposing PR
git config --file .gitmodules --get-regexp '.*\.url' \
| while read repo url; do
    owner_url="${url/github.com\/[^\/]*\//github.com/${repo_owner}/}"
    : url=$url
    : repo_owner=$repo_owner
    : owner_url=$owner_url
    git config --file .gitmodules "$repo" "$owner_url"
done

git submodule update --init --recursive

echo -e "section_end:$(date +%s):prepare\r\e[0K"

if is_pr; then
    echo -e "section_start:$(date +%s):build_orig\r\e[0KBuilding original site to compare"
    # exact value doesn't matter, but needs to be the same as in the other call
    # below
    echo 'time: 2020-01-01 00:00:00 +0100' >> _config.yml
    bundle exec jekyll build
    git checkout _config.yml

    echo moving old site
    mv _site ~/old_site
    echo -e "section_end:$(date +%s):build_orig\r\e[0K"
fi

echo -e "section_start:$(date +%s):build_current\r\e[0KBuilding site"
if [ "$repo_name" != "qubesos.github.io" ]; then
    sub_name=$(git config --file .gitmodules --list | grep -m1 -F -- "$repo_name" | cut -d. -f2)
    sub_path=$(git config --file .gitmodules --get -- "submodule.${sub_name}.path")
else
    sub_path="."
fi
git -C "$sub_path" fetch --update-shallow ${CI_PROJECT_DIR} HEAD
git -C "$sub_path" checkout FETCH_HEAD

echo 'time: 2020-01-01 00:00:00 +0100' >> _config.yml
bundle exec jekyll build
git checkout _config.yml

echo -e "section_end:$(date +%s):build_current\r\e[0K"

all_ok=true

if [ -d ~/old_site ]; then
    #echo -e "section_start:$(date +%s):diff\r\e[0Kdiffing"
    #diff -ur ~/old_site ./_site || true
    #echo -e "section_end:$(date +%s):diff\r\e[0K"

    echo
    echo "Spelling report for $CI_COMMIT_SHA:"
    echo
    _utils/spellcheck.sh ~/old_site _site || all_ok=false
    echo
fi

htmlproofer ./_site \
  --disable-external \
  --checks-to-ignore ImageCheck \
  --file-ignore ./_site/video-tours/index.html \
  --only_4xx \
  --url-ignore "/qubes-issues/" || all_ok=false

if $all_ok; then
    echo 'All checks passed!'
else
    echo 'Some checked failed. See above.'
    exit 1
fi
