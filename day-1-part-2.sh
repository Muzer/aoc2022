#!/bin/bash

declare -a max_cals
MAX_CALS_NUM=3
for ((i=0; i<MAX_CALS_NUM; ++i)); do
  max_cals["$i"]=-1
done
cur_cals=0

while read -r line; do
  if [ "a$line" = "a" ]; then
    cur_cals=0
    continue
  fi
  let cur_cals+=line
  if [ "$cur_cals" -gt "${max_cals["$((MAX_CALS_NUM - 1))"]}" ]; then
    max_cals["$((MAX_CALS_NUM - 1))"]="$cur_cals"
    for ((i="$((MAX_CALS_NUM - 2))"; i>=0; --i)); do
      if [ "${max_cals["$((i + 1))"]}" -gt "${max_cals["$i"]}" ]; then
        tmp="${max_cals["$i"]}"
        max_cals["$i"]="${max_cals["$((i + 1))"]}"
        max_cals["$((i + 1))"]="$tmp"
      fi
    done
  fi
done

total_max_cals=0
for ((i=0; i<MAX_CALS_NUM; ++i)); do
  let total_max_cals+=max_cals["$i"]
done
echo "$total_max_cals"
