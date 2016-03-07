#!/bin/bash
set -e

RESULTDIR=$HOME/results
USERNAME=demo
PASSWORD=demo
INITIAL="$(echo ${USERNAME} | head -c 1)"
TESTDIR=/local/users/${INITIAL}/${USERNAME}/testing
NUMREQ=5000


# Upload same file with or wirhout checksums
function bench_upload {
    OUT=${RESULTDIR}/`date +%Y%m%d%H%M`-$1-$NUMREQ-upload
    CONCURRENCY=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096)
    
    mkdir -p $OUT
    NUMPROVAS=5
    for((p=0; p<NUMPROVAS; p++)); do
        for i in ${CONCURRENCY[@]};do
        	clawiobench upload ${TESTDIR}/file-nochek --cern-distribution -n ${NUMREQ} -c $i --progress-bar=false -e $OUT/p-$p-n-$NUMREQ-c$i-cern.csv
	done;
    	sleep 5
	for i in `ls $OUT/p-$p-n-$NUMREQ-*-cern.csv`; do
	    cat $i | tail -n +2 >> $OUT/output-p-$p-n-$NUMREQ-cern.csv
	done;
	cat $OUT/output-p-$p-n-$NUMREQ-cern.csv | sort -g -k 2 > $OUT/output-p-$p-n-$NUMREQ-cern.csv-sorted
	mv $OUT/output-p-$p-n-$NUMREQ-cern.csv-sorted $OUT/output-p-$p-n-$NUMREQ-cern.csv
    done;
}

clawiobench login ${USERNAME} ${PASSWORD}
clawiobench home
./setup_test_scenario.sh
bench_upload $1
