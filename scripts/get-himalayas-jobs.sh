#!/bin/bash


##
# Usage:    ./script <output_file>
#
##

set -x

output_file=$1

current_offset=0
continue_loop=1
while [[ $continue_loop == 1 ]]; do
  res=$(curl -s "https://himalayas.app/jobs/api?offset=$current_offset")
  cat <<< $(jq -s 'add' $output_file <(jq '.jobs' <<< $res)) > $output_file

  res_limit=$(jq .limit <<< $res)
  res_total_count=$(jq .total_count <<< $res)
  (( current_offset += res_limit ))
  if [[ $current_offset -gt $res_total_count ]]; then
    continue_loop=0
  else
    sleep 1
  fi
done
