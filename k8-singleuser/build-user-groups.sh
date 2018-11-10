#!/bin/bash

# GROUP_BUILD="GROUP1:1234 GROUP2:22345"

GROUP_ARRAY=(${GROUP_BUILD})

for GROUP_ENTRY in ${GROUP_ARRAY[@]}; do
	GROUP_MAP=($(echo "${GROUP_ENTRY}" | tr ':' ' '))
	groupadd -fg "${GROUP_MAP[1]}" "${GROUP_MAP[0]}"
	usermod -a -G "${GROUP_MAP[0]}" "${NB_USER}"
done
