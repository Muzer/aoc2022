#!/bin/bash

declare -A rps_map
declare -a result_map

rps_map[A]=0
rps_map[B]=1
rps_map[C]=2
rps_map[X]=0
rps_map[Y]=1
rps_map[Z]=2

result_map[0]=3
result_map[1]=6
result_map[2]=0

total_score=0

while IFS=' ' read -r opp you; do
  you_num=${rps_map["$you"]}
  opp_num=${rps_map["$opp"]}

  result=$(( (3 + (you_num - opp_num)) % 3 ))

  let total_score+=result_map["$result"]+you_num+1
done

echo "$total_score"
