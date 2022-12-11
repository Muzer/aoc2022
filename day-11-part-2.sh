#!/bin/bash

# Could calculate LCM here, but I think this should be sufficient
monkey_mod=1

while IFS=' :' read -r Monkey monkey; do
  IFS=' :' read -r Starting items starting_items
  monkey_items["$monkey"]=monkey_items$monkey
  declare -n cur_items=${monkey_items["$monkey"]}
  IFS=', ' cur_items=( $starting_items )
  IFS=': ' read -r Operation new equals old operation operation_value
  IFS=': ' read -r Test divisible by test_value
  IFS=': ' read -r If true throw to txt_monkey true_value
  IFS=': ' read -r If false throw to txt_monkey false_value
  read -r
  monkey_op["$monkey"]=$operation
  monkey_op_value["$monkey"]=$operation_value
  monkey_test_value["$monkey"]=$test_value
  let monkey_mod*=test_value
  monkey_true_value["$monkey"]=$true_value
  monkey_false_value["$monkey"]=$false_value
done


for ((i=0; i<10000; ++i)); do
  for monkey in ${!monkey_op[@]}; do
    declare -n cur_items=${monkey_items["$monkey"]}
    while [ ${#cur_items[@]} -gt 0 ]; do
      worry=${cur_items[0]}
      cur_items=("${cur_items[@]:1}")
      if [ "${monkey_op_value["$monkey"]}" == "old" ]; then
        op_value=$worry
      else
        op_value=${monkey_op_value["$monkey"]}
      fi
      case "${monkey_op["$monkey"]}" in
        "+")
          let worry+=op_value
          ;;
        "*")
          let worry*=op_value
          ;;
      esac
      let ++monkey_insp_count["$monkey"]
      if [ $((worry % monkey_test_value["$monkey"])) -eq 0 ]; then
        target_monkey=${monkey_true_value["$monkey"]}
      else
        target_monkey=${monkey_false_value["$monkey"]}
      fi
      # Prevent overflows
      let worry%=monkey_mod
      declare -n target_items=${monkey_items["$target_monkey"]}
      target_items+=( $worry )
    done
  done
done

max_insp_count=0
second_insp_count=0

for insp_count in ${monkey_insp_count[@]}; do
  if [ $insp_count -gt $second_insp_count ]; then
    second_insp_count=$insp_count
  fi
  if [ $second_insp_count -gt $max_insp_count ]; then
    tmp=$max_insp_count
    max_insp_count=$second_insp_count
    second_insp_count=$tmp
  fi
done

echo $(( max_insp_count * second_insp_count ))
