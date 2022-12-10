#!/bin/bash

x=1
cycle=0

draw() {
  if [ $(( x - 1 )) -le $(( (cycle - 1) % 40 )) ] \
    && [ $(( x + 1 )) -ge $(( (cycle - 1) % 40 )) ]; then
    echo -en '\x1B[7m \x1B[0m'
  else
    echo -n ' '
  fi
  if [ $(( (cycle - 1) % 40 )) == 39 ]; then
    echo
  fi
}

while IFS=' ' read -r opcode arg; do
  let cycle++
  draw
  if [ "$opcode" == "addx" ]; then
    let cycle++
    draw
    let x+=arg
  fi
done
