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
