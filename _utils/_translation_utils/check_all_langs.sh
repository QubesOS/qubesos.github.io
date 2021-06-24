#!/bin/bash
# to be run from the git root
# $1 is directory where translated files reside and language needs to be added to internal urls
# TODO param check

set -e

echo "================================= build site =================================="
#read b
bundle exec jekyll b

all_ok=true
echo "================================= run htmlproofer ==============================="
htmlproofer ./_site   --disable-external   --checks-to-ignore ImageCheck   --file-ignore "./_site/video-tours/index.html,./_site/.*/video-tours/index.html" --url-ignore "/qubes-issues/" --log-level debug 2&> /tmp/html.output || all_ok=false

# exit here if all is ok
if $all_ok; then
    echo 'All checks passed!'
    exit
fi

echo "================================== as a last resort in case of errors process html proofer errors ================================="
python3 _utils/_translation_utils/postprocess_htmlproofer.py /tmp/html.output "$1"

echo "================================= build the site and run htmlproofer ===================================="
rm -rf ./_site/
bundle exec jekyll b
htmlproofer ./_site   --disable-external   --checks-to-ignore ImageCheck   --file-ignore "./_site/video-tours/index.html,./_site/.*/video-tours/index.html" --url-ignore "/qubes-issues/" --log-level debug
