#!/bin/bash

declare -A rps_map
declare -A result_num_map
declare -A result_score_map

rps_map[A]=0
rps_map[B]=1
rps_map[C]=2

result_num_map[X]=2
result_num_map[Y]=0
result_num_map[Z]=1

result_score_map[X]=0
result_score_map[Y]=3
result_score_map[Z]=6

total_score=0

while IFS=' ' read -r opp result; do
  result_num=${result_num_map["$result"]}
  result_score=${result_score_map["$result"]}
  opp_num=${rps_map["$opp"]}

  you_num=$(( (opp_num + result_num) % 3 ))

  let total_score+=result_score+you_num+1
done

echo "$total_score"
