#!/bin/sh

: ${SITE:=${1:-http://localhost:4000/}}

wget --spider \
    --recursive \
    --page-requisites \
    --execute robots=off \
    --wait 0.1 \
    "${SITE}" 2>&1 \
| grep '\(^--\|awaiting response\)' \
| grep -B1 --no-group-separator 404  \
| sed -ne '/^--/s+^.*  '"${SITE}"'+/+p' \
