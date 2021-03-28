#!/bin/bash
# $1 is tx/config file
# $2 filename to contain only the resources' names
# $3 filename to contain only the source files' names
sed '/^$/d' $1 | sed '/^s/d' | sed '/^t/d' | sed '/^h/d' | sed '/^f/d' | sed '/\[main]/d' | sed 's/\[//' | sed 's/\]//' | sed 's/.*\.//' > $2
sed '/^$/d' $1 | sed '/source_lang/d' | sed '/^t/d' | sed '/^h/d' | sed '/\[main]/d' | sed '/\[/d' | sed '/^f/d'  > $3
