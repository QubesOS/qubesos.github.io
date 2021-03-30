#!/bin/bash -e
# first argument is the language for which the translated files should be downloaded
# the mode developer will download all unreviewed translated strings as well
tx pull --force -l $1 --mode reviewed -d --traceback -r qubes.doc*
tx pull --force -l $1 --mode reviewed -d --traceback -r qubes.pages*
tx pull --force -l $1 --mode reviewed -d --traceback -r qubes.news*

# the different mode here is needed for YAML files, since the developer mode does not download source strings if untranslated
# the mode reviewed here will not work and will return empty strings for nontranslated ones
tx pull --force -l $1 --mode sourceastranslation -d --traceback -r qubes.data_*
