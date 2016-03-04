#!/bin/bash
DIR=$1
cd $DIR
cat output-p-* | cut -d" " -f2,5 | sort -n | uniq | awk '{Count[$1]++; Freq[$1]+=$2;} END {for (var in Count) print  var, Freq[var]/Count[var]}' | sort -n > mean.csv
cd -
