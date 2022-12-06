#!/bin/bash

max_cals=-1
cur_cals=0

while read -r line; do
  if [ "a$line" = "a" ]; then
    cur_cals=0
    continue
  fi
  let cur_cals+=line
  if [ "$cur_cals" -gt "$max_cals" ]; then
    max_cals="$cur_cals"
  fi
done

echo "$max_cals"
