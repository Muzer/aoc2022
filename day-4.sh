#!/bin/bash

count=0

while IFS=-, read -r from1 to1 from2 to2; do
  if [ "$from1" -le "$from2" ] && [ "$to1" -ge "$to2" ]; then
    let ++count
    continue
  fi
  if [ "$from2" -le "$from1" ] && [ "$to2" -ge "$to1" ]; then
    let ++count
    continue
  fi
done

echo "$count"
