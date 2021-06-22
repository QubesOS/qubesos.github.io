#!/bin/bash
# to be run from the git root
# $1 is lang
# $2 is directory where translated files reside and language needs to be added to internal urls
# TODO param check

set -e

echo "============================ post processing step 1 ======================================"
#read b
bash _utils/_translation_utils/prepare_tx_config_postprocess.sh .tx/config /tmp/tx-mapping

echo "============================ remove obsolete files ======================================="
python3 _utils/_translation_utils/remove_obsolete_files.py "$1" "$2" /tmp/tx-mapping

echo "============================ post processing step 2 ======================================"
#read b
ruby _utils/_translation_utils/merge_md_heading_ids.rb "$1" /tmp/tx-mapping

echo "============================ post processing step 3 press to cont ======================================"
#read b
python3 _utils/_translation_utils/postprocess_translation.py "$1" "$2"  /tmp/tx-mapping  /tmp/translated_href_urls.txt --yml


echo "============================ post processing step 4 press to cont ======================================"
#read b
bash _utils/_translation_utils/postprocess_translation.sh "$1" "$2" /tmp/translated_href_urls.txt


echo "================================= build site =================================="
#read b
bundle exec jekyll b

all_ok=true
echo "================================= run htmlproofer ==============================="
htmlproofer ./_site   --disable-external   --checks-to-ignore ImageCheck   --file-ignore "./_site/video-tours/index.html,./_site/$1/video-tours/index.html" --url-ignore "/qubes-issues/" --log-level debug 2&> /tmp/html.output || all_ok=false

# exit here if all is ok
if $all_ok; then
    echo 'All checks passed!'
    exit
fi

echo "================================== as a last resort in case of errors process html proofer errors ================================="
python3 _utils/_translation_utils/postprocess_htmlproofer.py "$1" /tmp/html.output "$2"

echo "================================= build the site and run htmlproofer ===================================="
rm -rf ./_site/
bundle exec jekyll b
htmlproofer ./_site   --disable-external   --checks-to-ignore ImageCheck   --file-ignore "./_site/video-tours/index.html,./_site/$1/video-tours/index.html" --url-ignore "/qubes-issues/" --log-level debug
