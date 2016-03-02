#!/bin/bash
set -e

RESULTDIR=$HOME/results
USERNAME=demo
PASSWORD=demo
INITIAL="$(echo ${USERNAME} | head -c 1)"
TESTDIR=/local/users/${INITIAL}/${USERNAME}/testing
NUMREQ=10000


# Stat with no depth = PROPFIND with Depth = 0
function bench_nochildren {
OUT=${RESULTDIR}/`date +%Y%m%d%H%M`-$1-$NUMREQ-nochildren
    CONCURRENCY=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096)
    #CONCURRENCY=(4096 2048 1024 512 256 128 64 32 16 8 4 2 1)
    #CONCURRENCY=(1 3 5 10 30 50 100 300 500 1000 3000)

    mkdir -p $OUT
    NUMPROVAS=5
    for((p=0; p<NUMPROVAS; p++)); do
        for i in ${CONCURRENCY[@]};do
            clawiobench stat ${TESTDIR} -n ${NUMREQ} -c $i --progress-bar=false -e $OUT/p-$p-n-$NUMREQ-c$i-nochildren.csv
        done;
        for i in `ls $OUT/p-$p-n-$NUMREQ-*-nochildren*`; do
            cat $i | tail -n +2 >> $OUT/output-p-$p-n-$NUMREQ-nochildren.csv
        done;
        cat $OUT/output-p-$p-n-$NUMREQ-nochildren.csv | sort -g -k 2 > $OUT/output-p-$p-n-$NUMREQ-nochildren.csv-sorted
        mv $OUT/output-p-$p-n-$NUMREQ-nochildren.csv-sorted $OUT/output-p-$p-n-$NUMREQ-nochildren.csv
	sleep 5
    done;
    cp generate_plot.gpl $OUT
    cd $OUT
    gnuplot -e "title='$1'" generate_plot.gpl
}

clawiobench login ${USERNAME} ${PASSWORD}
clawiobench home
bench_nochildren $1