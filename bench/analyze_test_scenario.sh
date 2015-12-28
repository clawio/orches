#!/bin/bash
set -e

RESULTDIR=/home/hugo/results
USERNAME=demo
PASSWORD=demo
INITIAL="$(echo ${USERNAME} | head -c 1)"
TESTDIR=/local/users/${INITIAL}/${USERNAME}
NUMREQ=10000


# Stat with no depth = PROPFIND with Depth = 0
function bench_nochildren {
    OUT=${RESULTDIR}/$1-$NUMREQ-nochildren
    CONCURRENCY=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096)

    mkdir -p $OUT
    NUMPROVAS=5
    for((p=0; p<NUMPROVAS; p++)); do
        for i in ${CONCURRENCY[@]};do
            clawiobench stat ${TESTDIR} -n ${NUMREQ} -c $i --progress-bar=false -e $OUT/p-$p-n-$NUMREQ-c$i-nochildren.csv
        done;
        for i in `ls $OUT/p-$p-n-$NUMREQ-*-nochildren*`; do
            cat $i | tail -n +2 >> $OUT/output-p-$p-n-$NUMREQ-nochildren.csv
        done;
        cat $OUT/output-p-$p-n-$NUMREQ-nochildren.csv | sort -t"," -g -k 2 > $OUT/output-p-$p-n-$NUMREQ-nochildren.csv-sorted
        mv $OUT/output-p-$p-n-$NUMREQ-nochildren.csv-sorted $OUT/output-p-$p-n-$NUMREQ-nochildren.csv
    done;
}

clawiobench login ${USERNAME} ${PASSWORD}
clawiobench home
bench_nochildren $1
