#!/bin/sh

grep -rn --color=auto '\[\(.*\)?\]([^)]*\1)' "$@"
