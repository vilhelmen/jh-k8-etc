#!/bin/bash

# GROUP_BUILD="GROUP1:1234 GROUP2:22345"

GROUP_ARRAY=(${GROUP_BUILD})

for GROUP_ENTRY in ${GROUP_ARRAY[@]}; do
	GROUP_MAP=($(echo "${GROUP_ENTRY}" | tr ':' ' '))
	groupadd -fg "${GROUP_MAP[1]}" "${GROUP_MAP[0]}"
done

GROUP_MEMBER_ARRAY=(${GROUP_MEMBER})
for MEMBER_GID in ${GROUP_MEMBER_ARRAY[@]}; do
	usermod -a -G "${MEMBER_GID}" "${NB_USER}"
done
