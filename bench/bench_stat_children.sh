#!/bin/bash
set -e

RESULTDIR=$HOME/results
USERNAME=demo
PASSWORD=demo
INITIAL="$(echo ${USERNAME} | head -c 1)"
TESTDIR=/local/users/${INITIAL}/${USERNAME}/testing
NUMREQ=5000


# Stat with depth 1 = PROPFIND with Depth = 1
function bench_children {
    OUT=${RESULTDIR}/`date +%Y%m%d%H%M`-$1-$NUMREQ-children
    CONCURRENCY=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096)
    CHILDREN=(1 2 4 8 16 32 64 128 256 512 1024)

    mkdir -p $OUT
    NUMPROVAS=5
    for((p=0; p<NUMPROVAS; p++)); do
        for i in ${CONCURRENCY[@]};do
		for k in ${CHILDREN[@]}; do
            		clawiobench stat ${TESTDIR}/$k --children -n ${NUMREQ} -c $i --progress-bar=false -e $OUT/p-$p-n-$NUMREQ-c$i-children-$k.csv
		done;
	done;
    	sleep 5
    done;
}

clawiobench login ${USERNAME} ${PASSWORD}
clawiobench home
bench_children $1
