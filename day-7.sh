#!/bin/bash

cursubpaths=(/)
declare -A dirsizes

while IFS=' ' read -r size name arg; do
  case "$size" in
    dir)
      continue
      ;;
    "$")
      case "$name" in
        ls)
          continue
          ;;
        cd)
          if [ "a$arg" = "a.." ]; then
            unset cursubpaths[-1]
          else
            cursubpaths+=("${cursubpaths[-1]}/$arg")
          fi
          continue
          ;;
      esac
  esac
  # will now be a size
  for subpath in "${cursubpaths[@]}"; do
    let dirsizes["$subpath"]+=size
  done
done

total=0

for size in "${dirsizes[@]}"; do
  if [ "$size" -le 100000 ]; then
    let total+=size
  fi
done

echo "$total"
