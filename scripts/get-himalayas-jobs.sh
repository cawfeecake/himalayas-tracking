#!/bin/bash

## Usage
# * 1st arg (req.): filename for the resulting jobs json array
##

set -x

# setup user args

jobs_file=$1
if [ -z "$jobs_file" ]; then
    echo "Required: filename to put results"
    exit 1
else
    > $jobs_file
fi

# begin API quer(ies)

current_offset=0
continue_loop=1
while [ "$continue_loop" -gt 0 ]; do
    temp_file=$(mktemp)
    curl -s "https://himalayas.app/jobs/api?offset=$current_offset" > $temp_file
    cat <<< $(jq -s 'add' $jobs_file <(jq '.jobs' $temp_file)) > $jobs_file

    res_limit=$(jq .limit $temp_file)
    res_total_count=$(jq .total_count $temp_file)
    (( current_offset += res_limit ))
    if [ "$current_offset" -ge "$res_total_count" ]; then
        continue_loop=0
    else
        sleep 1
    fi
done
