#! /usr/bin/env bash

function usage() {

echo "usage: $0 [find|replace] [path_to_dir]"
echo '''
This helper script replaces all {% highlight trac-wiki %}
and {% endhighlight %} trac wiki leftovers.
'''


}

function findOrReplace() {
  mode="$1"
  dir="$2"

  while IFS= read -r -d $'\0' file
  do
    lines=`cat "$file" | grep -E "\{% .* %}" | wc -l`

    if [[ "$lines" > 0 ]]
    then
      if [[ "$mode" == "replace" ]]
      then
        sed -i 's/{% .* %}/```/g' "$file"
      else
        echo "$file"
      fi
    fi
  done < <( find "$dir" -name "*.md" -type f -print0 )
}

if [[ "$#" == 2 ]]
then
  cmd="$1"
  folder="$2"

  if [[ -d "$folder" ]]
  then
    findOrReplace "$cmd" "$folder"
  else
    echo "Folder '$folder' not found"
  fi
else
  usage
  exit 1
fi

exit 0
