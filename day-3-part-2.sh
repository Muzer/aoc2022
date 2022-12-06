#!/bin/bash

priorities=0

while read -r line; do
  read -r line2
  read -r line3
  unset items
  declare -A items
  len=${#line}
  for ((i=0; i<len; ++i)); do
    items["${line:$i:1}"]=1
  done
  len2=${#line2}
  for ((i=0; i<len2; ++i)); do
    char=${line2:$i:1}
    if [ "a${items["$char"]}" = "a1" ]; then
      items["$char"]=2
    fi
  done
  len3=${#line3}
  for ((i=0; i<len3; ++i)); do
    char=${line3:$i:1}
    if [ "a${items["$char"]}" = "a2" ]; then
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
