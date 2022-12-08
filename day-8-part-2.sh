#!/bin/bash

rows=()

while read -r line; do
  rows+=($line)
done

maxscore=0

for ((i=0; i<${#rows[@]}; ++i)); do
  for ((j=0; j<${#rows[0]}; ++j)); do
    # Consider tree j,i
    score=1 # you can always see at least one tree
    x=$(( j - 1 ))
    while [ $x -ge 0 ] && [ ${rows[$i]:$x:1} -lt ${rows[$i]:$j:1} ]; do
      let ++score
      let --x
    done
    if [ "$x" -lt 0 ]; then
      let --score
    fi
    scorebuf=$score
    score=1
    x=$(( j + 1 ))
    while [ $x -lt ${#rows[0]} ] && [ ${rows[$i]:$x:1} -lt ${rows[$i]:$j:1} ]; do
      let ++score
      let ++x
    done
    if [ "$x" -ge ${#rows[0]} ]; then
      let --score
    fi
    scorebuf=$(( scorebuf * score ))
    score=1
    y=$(( i - 1 ))
    while [ $y -ge 0 ] && [ ${rows[$y]:$j:1} -lt ${rows[$i]:$j:1} ]; do
      let ++score
      let --y
    done
    if [ "$y" -lt 0 ]; then
      let --score
    fi
    scorebuf=$(( scorebuf * score ))
    score=1
    y=$(( i + 1 ))
    while [ $y -lt ${#rows[@]} ] && [ ${rows[$y]:$j:1} -lt ${rows[$i]:$j:1} ]; do
      let ++score
      let ++y
    done
    if [ "$y" -ge ${#rows[@]} ]; then
      let --score
    fi
    scorebuf=$(( scorebuf * score ))
    if [ "$scorebuf" -gt "$maxscore" ]; then
      maxscore=$scorebuf
    fi
  done
done

echo "$maxscore"
