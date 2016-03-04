#!/bin/bash
set -e

USERNAME=demo
PASSWORD=demo

SCENARIOS=(localfs localfsxattr_mysql localfsxattr_redis)
OPERATIONS=(stat_nochildren upload)

for i in ${SCENARIOS[@]};do
	source envs/$i
	for j in ${OPERATIONS[@]};do
		op=bench_$j.sh
		./$op $i 
	done;
done;
