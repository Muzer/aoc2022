#!/bin/bash

# input will be a normal array of strings, albeit with the "Start" and "End"
# squares replaced with their appropriate heights
declare -a input

# pathlen will be an associative array with key x,y showing the min length to
# that square.
declare -A pathlen

# todo will be an array of x,y in the todo list; the LAST entry is first
declare -a todo

# this one's self-explanatory
declare -A alphabet

i=0
for letter in {a..z}; do
  alphabet[$letter]=$i
  let ++i
done

y=0
while read -r line; do
  for ((x=0; x<${#line}; ++x)); do
    if [ "${line:$x:1}" == "E" ]; then
      line=${line:0:$x}z${line:$((x + 1))}
      startx=$x
      starty=$y
    elif [ "${line:$x:1}" == "S" ]; then
      line=${line:0:$x}a${line:$((x + 1))}
    fi
  done
  input[$y]=$line
  let ++y
done

check_square() {
  if [ $1 -lt 0 ] || [ $2 -lt 0 ] || \
    [ $1 -ge ${#input[0]} ] || [ $2 -ge ${#input[@]} ]; then
    return
  fi
  if [ "a${pathlen[$1,$2]}" != "a" ]; then
    return
  fi
  local new_height
  new_height=${input[$2]:$1:1}
  if [ $(( alphabet[$new_height] )) -ge $(( alphabet[$height] - 1 )) ]; then
    todo=( "$1,$2" "${todo[@]}" )
    pathlen[$1,$2]=$len
  fi
}

x=$startx
y=$starty
len=0
height=z
while [ "$height" != "a" ]; do
  let ++len
  check_square $(( x + 1 )) $y
  check_square $(( x - 1 )) $y
  check_square $x $(( y + 1 ))
  check_square $x $(( y - 1 ))
  
  next_coords=${todo[-1]}
  x=${next_coords%','*}
  y=${next_coords#*','}
  len=${pathlen[$x,$y]}
  height=${input[$y]:$x:1}
  unset todo[-1]
done

echo "$len"
