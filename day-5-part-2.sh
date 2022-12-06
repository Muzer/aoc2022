#!/bin/bash

declare -a columns # we store an array of columns (indexed from 1, ew), the
                   # column contents is a string with the start of the string
                   # being the top of the column

while IFS= read -r line; do
  if [ "a${line:1:1}" = "a1" ]; then # this is the column numbers which aren't
                                     # interesting as they're always(?) in
                                     # order
    read -r line # get the blank line out of the way
    break
  fi

  len=${#line}

  for ((i=1; i<len; i+=4)); do
    char="${line:$i:1}"
    if [ "a$char" != "a " ]; then
      col=$(( ( (i - 1) / 4 ) + 1 ))
      columns["$col"]="${columns["$col"]}$char"
    fi
  done
done

while IFS=' ' read -r move num from fromcol to tocol; do
  columns["$tocol"]=${columns["$fromcol"]:0:$num}${columns["$tocol"]}
  columns["$fromcol"]=${columns["$fromcol"]:$num}
done

for col_str in "${columns[@]}"; do
  echo -n "${col_str:0:1}"
done

echo
