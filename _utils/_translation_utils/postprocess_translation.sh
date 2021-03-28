#!/bin/bash
# $1 is lang
# $2 is directory where translated files reside and language needs to be added to internal urls
# $3 is file with internal urls that belong to files already translated and downloaded from transifex to be replaced with lang/url
# where $3 is a file dumped by postprocess_translation.py 
# this script exists because is easier to correctly process html code with sed. python messes it up.
# example of evoking the script:
# bash _utils/_translation_utils/test.sh de _qubes-translated/de/ _utils/translated_hrefs_urls.txt


pattern="href=\"\/"
pattern_reset="href=\"\/"$1"\/"
escaped_slash="\/"

# find the patterns that contain href=/$lang pattern and reset
find $2 -name '*.md' -or -name '*.html' | xargs sed -i "s/$pattern_reset/$pattern/g"

while read line; do
	# check for traversing patterns in $3: check if every line begins with /word
	if [ -z `grep -oP '^(/(\w+))*' <<< $line` ] 
	then
		echo "the string does not begin as it should"
		exit 0 
	fi
	#escape '/' with '\/' 
	l="${line//\//$escaped_slash}"
	search_pattern="href=\""$l"\""
	replace_pattern="href=\"\/"$1$l"\""

	# search and destroy
	find $2 -name '*.md' -or -name '*.html' | xargs sed -i "s/$search_pattern/$replace_pattern/g"
done < $3

