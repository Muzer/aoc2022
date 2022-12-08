#!/bin/bash

rows=()

while read -r line; do
  rows+=($line)
done

declare -A visible # x,y visible

maxheight=${rows[0]}

for ((i=0; i<${#maxheight}; ++i)); do
  visible[$i,0]=1
done

for ((i=1; i<${#rows[@]}; ++i)); do
  for ((j=0; j<${#maxheight}; ++j)); do
    if [ "${rows[$i]:$j:1}" -gt "${maxheight:$j:1}" ]; then
      visible[$j,$i]=1
      maxheight=${maxheight:0:$j}${rows[$i]:$j:1}${maxheight:$((j + 1))}
    fi
  done
done

maxheight=${rows[-1]}

for ((i=0; i<${#maxheight}; ++i)); do
  visible[$i,$(( ${#rows[@]} - 1 ))]=1
done

for ((i=${#rows[@]}-2; i>=0; --i)); do
  for ((j=0; j<${#maxheight}; ++j)); do
    if [ "${rows[$i]:$j:1}" -gt "${maxheight:$j:1}" ]; then
      visible[$j,$i]=1
      maxheight=${maxheight:0:$j}${rows[$i]:$j:1}${maxheight:$((j + 1))}
    fi
  done
done

maxheight=
for ((i=0; i<${#rows[@]}; ++i)); do
  maxheight=${maxheight}${rows[$i]:0:1}
done

for ((i=0; i<${#maxheight}; ++i)); do
  visible[0,$i]=1
done

for ((i=1; i<${#rows[0]}; ++i)); do
  for ((j=0; j<${#maxheight}; ++j)); do
    if [ "${rows[$j]:$i:1}" -gt "${maxheight:$j:1}" ]; then
      visible[$i,$j]=1
      maxheight=${maxheight:0:$j}${rows[$j]:$i:1}${maxheight:$((j + 1))}
    fi
  done
done

maxheight=
for ((i=0; i<${#rows[@]}; ++i)); do
  maxheight=${maxheight}${rows[$i]:$(( ${#rows[0]} - 1 )):1}
done
for ((i=0; i<${#maxheight}; ++i)); do
  visible[$(( ${#rows[0]} - 1 )),$i]=1
done

for ((i=${#rows[0]}-2; i>=0; --i)); do
  for ((j=0; j<${#maxheight}; ++j)); do
    if [ "${rows[$j]:$i:1}" -gt "${maxheight:$j:1}" ]; then
      visible[$i,$j]=1
      maxheight=${maxheight:0:$j}${rows[$j]:$i:1}${maxheight:$((j + 1))}
    fi
  done
done

total=0

for tree in "${visible[@]}"; do
  if [ "a$tree" = "a1" ]; then
    let total+=1
  fi
done

echo "$total"
