#!/bin/bash

read -r line

declare -A chars

for ((i=0; i<"${#line}"; ++i)); do
  char="${line:$i:1}"
  let ++chars["$char"]
  if [ "$i" -lt 3 ]; then
    continue
  fi
  if [ "$i" -ge 4 ]; then
    to_del=$(( i - 4 ))
    to_del_char="${line:$to_del:1}"
    let --chars["$to_del_char"]
  fi
  bad=0
  for count in "${chars[@]}"; do
    if [ "$count" != "1" ] && [ "$count" != "0" ]; then
      bad=1
      break
    fi
  done
  if [ "$bad" = 0 ]; then
    echo $(( i + 1 ))
    break
  fi
done
