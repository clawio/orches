#!/bin/bash
set -e

RESULTDIR=/home/hugo/results
USERNAME=demo
PASSWORD=demo
INITIAL="$(echo ${USERNAME} | head -c 1)"
TESTDIR=/local/users/${INITIAL}/${USERNAME}
NUMREQ=5000

clawiobench login ${USERNAME} ${PASSWORD}
clawiobench home

# Stat with no depth = PROPFIND with Depth = 0

CONCURRENCY=(1 2 4 8 16 32 64 128 256 512 1024)
for i in ${CONCURRENCY[@]};do
    clawiobench stat ${TESTDIR} -n ${NUMREQ} -c $i --progress-bar=false -e $RESULTDIR/clawiobench-$NUMREQ-$i-nochildren.csv
done;

cat $RESULTDIR/clawiobench-$NUMREQ-*-nochildren* | head -1 > $RESULTDIR/clawiobench-$NUMREQ-nochildren.csv
for i in `ls $RESULTDIR/clawiobench-$NUMREQ-*-nochildren*`; do
    cat $i | tail -n +2 >> $RESULTDIR/clawiobench-$NUMREQ-nochildren.csv
done;

cat $RESULTDIR/clawiobench-$NUMREQ-nochildren.csv | sort -g -k 2 > $RESULTDIR/clawiobench-$NUMREQ-nochildren-sorted.csv 


