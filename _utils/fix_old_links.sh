#!/bin/sh

sed -i -e 's+https\?://wiki.qubes-os.org/\(trac/\)\?wiki+/doc+g' "$@"
