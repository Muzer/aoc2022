#!/bin/bash

compare_lines() {
  while true; do
    if [ "$forcereturn" == "1" ]; then
      if [ "$endlisti" -gt 0 ]; then
        if [ "$endlistj" -gt 0 ]; then
          let --endlisti
          let --endlistj
          return 0
        fi
        return 1
      fi
      if [ "$endlistj" -gt 0 ]; then
        return 2
      fi
      forcereturn=0
    fi
    if [ "${line1[$i]:0:1}" == "[" ] || [ "${line2[$j]:0:1}" == "[" ]; then
      # recurse! Recurse!
      if [ "${line1[$i]:0:1}" == "[" ]; then
        line1[$i]=${line1[$i]:1}
      else
        let ++endlisti
      fi
      if [ "${line2[$j]:0:1}" == "[" ]; then
        line2[$j]=${line2[$j]:1}
      else
        let ++endlistj
      fi
      compare_lines
      res=$?
      if [ "$res" -ne 0 ]; then
        return $res
      fi
      continue
    fi
    while [ "${line1[$i]: -1}" == "]" ]; do
      line1[$i]=${line1[$i]:0:$(( ${#line1[$i]} - 1))}
      let ++endlisti
    done
    while [ "${line2[$j]: -1}" == "]" ]; do
      line2[$j]=${line2[$j]:0:$(( ${#line2[$j]} - 1))}
      let ++endlistj
    done
    # Even now, we could have empty lists - these are a special case because
    # reasons
    if [ "a${line1[$i]}" == "a" ]; then
      if [ "a${line2[$j]}" != "a" ]; then
        return 1
      fi
    elif [ "a${line2[$j]}" == "a" ]; then
      return 2
    else
      if [ "${line1[$i]}" -lt "${line2[$j]}" ]; then
        return 1
      elif [ "${line1[$i]}" -gt "${line2[$j]}" ]; then
        return 2
      fi
    fi
    let ++i
    let ++j
    if [ "$endlisti" -gt 0 ]; then
      if [ "$endlistj" -gt 0 ]; then
        forcereturn=1
        return 0
      fi
      return 1
    fi
    if [ "$endlistj" -gt 0 ]; then
      return 2
    fi
  done
}

declare -a finallines
while read -r line; do
  if [ "a$line" == "a" ]; then
    continue
  fi
  pos="${#finallines[@]}"
  finallines+=("$line")

  while [ "$pos" -gt 0 ]; do
    i=0
    j=0
    endlisti=0
    endlistj=0
    forcereturn=0
    IFS=',' read -ra line1 <<< "${finallines[$pos]}"
    IFS=',' read -ra line2 <<< "${finallines[$(( pos - 1 ))]}"
    compare_lines

    res=$?
    if [ "$res" -ne 1 ]; then
      break
    fi
    finallines=( "${finallines[@]:0:$(( pos - 1 ))}" "${finallines[$pos]}" \
      "${finallines[$(( pos - 1 ))]}" "${finallines[@]:$(( pos + 1 ))}" )
    let --pos
  done
done

result=1
pos="${#finallines[@]}"
finallines+=("[[2]]")

while [ "$pos" -gt 0 ]; do
  i=0
  j=0
  endlisti=0
  endlistj=0
  forcereturn=0
  IFS=',' read -ra line1 <<< "${finallines[$pos]}"
  IFS=',' read -ra line2 <<< "${finallines[$(( pos - 1 ))]}"
  compare_lines

  res=$?
  if [ "$res" -ne 1 ]; then
    break
  fi
  finallines=( "${finallines[@]:0:$(( pos - 1 ))}" "${finallines[$pos]}" \
    "${finallines[$(( pos - 1 ))]}" "${finallines[@]:$(( pos + 1 ))}" )
  let --pos
done
let result*=pos+1

pos="${#finallines[@]}"
finallines+=("[[6]]")

while [ "$pos" -gt 0 ]; do
  i=0
  j=0
  endlisti=0
  endlistj=0
  forcereturn=0
  IFS=',' read -ra line1 <<< "${finallines[$pos]}"
  IFS=',' read -ra line2 <<< "${finallines[$(( pos - 1 ))]}"
  compare_lines

  res=$?
  if [ "$res" -ne 1 ]; then
    break
  fi
  finallines=( "${finallines[@]:0:$(( pos - 1 ))}" "${finallines[$pos]}" \
    "${finallines[$(( pos - 1 ))]}" "${finallines[@]:$(( pos + 1 ))}" )
  let --pos
done
let result*=pos+1

echo "$result"
