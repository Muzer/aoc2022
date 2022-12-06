#!/bin/bash

priorities=0

while read -r line; do
  unset items
  declare -A items
  len=${#line}
  for ((i=0; i<len/2; ++i)); do
    items["${line:$i:1}"]=1
  done
  for ((i=len/2; i<len; ++i)); do
    char=${line:$i:1}
    if [ "a${items["$char"]}" = "a1" ]; then
      if LC_COLLATE=C [ "a$char" \< "aa" ]; then
        let priorities+=27+"$(LC_CTYPE=C printf '%d' "'$char")"-"$(LC_CTYPE=C printf '%d' "'A")"
      else
        let priorities+=1+"$(LC_CTYPE=C printf '%d' "'$char")"-"$(LC_CTYPE=C printf '%d' "'a")"
      fi
      break
    fi
  done
done

echo "$priorities"
