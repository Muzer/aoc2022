#!/bin/bash

xpos=0
ypos=0
tailxpos=0
tailypos=0
declare -A visited
visited["$tailxpos","$tailypos"]=1

while IFS=' ' read -r direction count; do
  for ((i=0; i<count; ++i)); do
    case "$direction" in
      U)
        let ++ypos
        if [ $(( ypos - 1 )) -gt $tailypos ]; then
          let ++tailypos
          if [ $tailxpos -gt $xpos ]; then
            let --tailxpos
          elif [ $tailxpos -lt $xpos ]; then
            let ++tailxpos
          fi
        fi
        ;;
      D)
        let --ypos
        if [ $(( ypos + 1 )) -lt $tailypos ]; then
          let --tailypos
          if [ $tailxpos -gt $xpos ]; then
            let --tailxpos
          elif [ $tailxpos -lt $xpos ]; then
            let ++tailxpos
          fi
        fi
        ;;
      L)
        let --xpos
        if [ $(( xpos + 1 )) -lt $tailxpos ]; then
          let --tailxpos
          if [ $tailypos -gt $ypos ]; then
            let --tailypos
          elif [ $tailypos -lt $ypos ]; then
            let ++tailypos
          fi
        fi
        ;;
      R)
        let ++xpos
        if [ $(( xpos - 1 )) -gt $tailxpos ]; then
          let ++tailxpos
          if [ $tailypos -gt $ypos ]; then
            let --tailypos
          elif [ $tailypos -lt $ypos ]; then
            let ++tailypos
          fi
        fi
        ;;
    esac
    visited["$tailxpos","$tailypos"]=1
  done
done

total=0
for item in "${visited[@]}"; do
  if [ "a$item" = "a1" ]; then
    let ++total
  fi
done
echo "$total"
