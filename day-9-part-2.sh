#!/bin/bash

for ((i=0; i<10; ++i)); do
  xpos[$i]=0
  ypos[$i]=0
done
declare -A visited
visited["${xpos[9]}","${ypos[9]}"]=1

do_up () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let ++ypos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( ypos[$knot] - 1 )) -gt ${ypos[$tail]} ]; then
      if [ ${xpos[$tail]} -gt ${xpos[$knot]} ]; then
        do_up_left $tail
      elif [ ${xpos[$tail]} -lt ${xpos[$knot]} ]; then
        do_up_right $tail
      else
        do_up $tail
      fi
    fi
  fi
}

do_up_left () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let ++ypos[$knot]
  let --xpos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( ypos[$knot] - 1 )) -gt ${ypos[$tail]} ]; then
      if [ ${xpos[$tail]} -gt ${xpos[$knot]} ]; then
        do_up_left $tail
      elif [ ${xpos[$tail]} -lt ${xpos[$knot]} ]; then
        do_up_right $tail
      else
        do_up $tail
      fi
    elif [ $(( xpos[$knot] + 1 )) -lt ${xpos[$tail]} ]; then
      if [ ${ypos[$tail]} -gt ${ypos[$knot]} ]; then
        do_down_left $tail
      elif [ ${ypos[$tail]} -lt ${ypos[$knot]} ]; then
        do_up_left $tail
      else
        do_left $tail
      fi
    fi
  fi
}

do_up_right () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let ++ypos[$knot]
  let ++xpos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( ypos[$knot] - 1 )) -gt ${ypos[$tail]} ]; then
      if [ ${xpos[$tail]} -gt ${xpos[$knot]} ]; then
        do_up_left $tail
      elif [ ${xpos[$tail]} -lt ${xpos[$knot]} ]; then
        do_up_right $tail
      else
        do_up $tail
      fi
    elif [ $(( xpos[$knot] - 1 )) -gt ${xpos[$tail]} ]; then
      if [ ${ypos[$tail]} -gt ${ypos[$knot]} ]; then
        do_down_right $tail
      elif [ ${ypos[$tail]} -lt ${ypos[$knot]} ]; then
        do_up_right $tail
      else
        do_right $tail
      fi
    fi
  fi
}

do_down () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let --ypos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( ypos[$knot] + 1 )) -lt ${ypos[$tail]} ]; then
      if [ ${xpos[$tail]} -gt ${xpos[$knot]} ]; then
        do_down_left $tail
      elif [ ${xpos[$tail]} -lt ${xpos[$knot]} ]; then
        do_down_right $tail
      else
        do_down $tail
      fi
    fi
  fi
}

do_down_left () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let --ypos[$knot]
  let --xpos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( ypos[$knot] + 1 )) -lt ${ypos[$tail]} ]; then
      if [ ${xpos[$tail]} -gt ${xpos[$knot]} ]; then
        do_down_left $tail
      elif [ ${xpos[$tail]} -lt ${xpos[$knot]} ]; then
        do_down_right $tail
      else
        do_down $tail
      fi
    elif [ $(( xpos[$knot] + 1 )) -lt ${xpos[$tail]} ]; then
      if [ ${ypos[$tail]} -gt ${ypos[$knot]} ]; then
        do_down_left $tail
      elif [ ${ypos[$tail]} -lt ${ypos[$knot]} ]; then
        do_up_left $tail
      else
        do_left $tail
      fi
    fi
  fi
}

do_down_right () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let --ypos[$knot]
  let ++xpos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( ypos[$knot] + 1 )) -lt ${ypos[$tail]} ]; then
      if [ ${xpos[$tail]} -gt ${xpos[$knot]} ]; then
        do_down_left $tail
      elif [ ${xpos[$tail]} -lt ${xpos[$knot]} ]; then
        do_down_right $tail
      else
        do_down $tail
      fi
    elif [ $(( xpos[$knot] - 1 )) -gt ${xpos[$tail]} ]; then
      if [ ${ypos[$tail]} -gt ${ypos[$knot]} ]; then
        do_down_right $tail
      elif [ ${ypos[$tail]} -lt ${ypos[$knot]} ]; then
        do_up_right $tail
      else
        do_right $tail
      fi
    fi
  fi
}

do_left () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let --xpos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( xpos[$knot] + 1 )) -lt ${xpos[$tail]} ]; then
      if [ ${ypos[$tail]} -gt ${ypos[$knot]} ]; then
        do_down_left $tail
      elif [ ${ypos[$tail]} -lt ${ypos[$knot]} ]; then
        do_up_left $tail
      else
        do_left $tail
      fi
    fi
  fi
}

do_right () {
  local knot
  local tail
  knot=$1
  tail=$(( knot + 1 ))
  let ++xpos[$knot]
  if [ "$tail" -le 9 ]; then
    if [ $(( xpos[$knot] - 1 )) -gt ${xpos[$tail]} ]; then
      if [ ${ypos[$tail]} -gt ${ypos[$knot]} ]; then
        do_down_right $tail
      elif [ ${ypos[$tail]} -lt ${ypos[$knot]} ]; then
        do_up_right $tail
      else
        do_right $tail
      fi
    fi
  fi
}

while IFS=' ' read -r direction count; do
  for ((i=0; i<count; ++i)); do
    case "$direction" in
      U)
        do_up 0
        ;;
      D)
        do_down 0
        ;;
      L)
        do_left 0
        ;;
      R)
        do_right 0
        ;;
    esac
    visited["${xpos[9]}","${ypos[9]}"]=1
  done
done

total=0
for item in "${visited[@]}"; do
  if [ "a$item" = "a1" ]; then
    let ++total
  fi
done
echo "$total"
