#!/bin/bash

x=1
cycle=0
total=0

while IFS=' ' read -r opcode arg; do
  let cycle++
  if [ "$(( (cycle + 20) % 40 ))" == 0 ]; then
    let total+=x*cycle
  fi
  if [ "$opcode" == "addx" ]; then
    let cycle++
    if [ "$(( (cycle + 20) % 40 ))" == 0 ]; then
      let total+=x*cycle
    fi
    let x+=arg
  fi
done

echo "$total"
