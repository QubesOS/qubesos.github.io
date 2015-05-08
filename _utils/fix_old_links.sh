#!/bin/sh

sed -i -e 's+https\?://wiki.qubes-os.org/\(trac/\)\?wiki/\([a-zA-Z/_-]*\)+/doc/\2/+g' "$@"
